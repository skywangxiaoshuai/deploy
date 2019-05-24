class V1::UsersController < ApplicationController
  include Utilities
  before_action :get_current_user, except: :login
  before_action :set_user, only: [:show, :reset_password, :update, :destroy, :update_profile, :modify_password]

  #获取用户列表
  #get /v1/users?page=xx&size=xx
  def index
    #权限验证
    authorize User
    page = params[:page]? params[:page] : 1
    users = @current_user.userable.users
                .where("is_disabled = ? and is_deleted = ?", false, false).page(page).per(params[:size])
    render status: 200, json: users, meta: pagination_dict(users), each_serializer: UserInfoSerializer
  end

  #查看用户详情
  #get /v1/users/:id
  def show
    authorize @user
    render status: 200, json: @user, serializer: UserInfoSerializer
  end

  #重置密码(运营商管理员、代理商管理员、商户管理员权限)
  #put /v1/users/:id/reset_password
  def reset_password
    authorize @user
    if @user.update(reset_password_params)
      render status: 200
    else
      render_422(@user)
    end
  end

  #更新用户信息
  #put /v1/users/:id
  def update
    authorize @user
    parameters = update_params
    #如果角色有变动，则前端把用户的所有角色都传过来,如果没有变动，则传空数组
    role_id = parameters[:role_id]
    if @user.update(parameters.except(:role_id))
      if role_id.present?
        #先把用户原有的角色删除，再重新添加
        @user.roles.delete_all
        @user.add_role(role_id)
      end
      render status: 200
    else
      render_422(@user)
    end
  end

  # #添加用户
  # #post /v1/users
  # def create
  #   #验证当前用户的权限能不能创建用户
  #   authorize User
  #   parameters = create_params
  #   user = @current_user.userable.users.new(parameters.except(:role_id))
  #   if user.save
  #     if user.add_role(parameters[:role_id])
  #       render status: 201
  #     else
  #       user.destroy
  #       user.errors.add(:error, "角色添加失败")
  #       render_422(user)
  #     end
  #   else
  #     render_422(user)
  #   end
  # end

  #删除用户
  #delete /v1/users/:id
  def destroy
    authorize @user
    @user.update(is_deleted: true)
    @user.roles.delete_all
    render status: 204
  end

  #用户登录
  #post /v1/login
  def login
    # binding.pry
    password = params[:data][:attributes][:password]
    login_name = params[:data][:attributes][:login_name]
    user = User.find_by(login_name: login_name, is_deleted: false)
    return render status: 404 unless user
    #如果该帐号是平台、代理商、或者商户的登录帐号，则需要检查帐号的审核状态（该审核状态与代理商或者商户的审核状态保持一致）
    case user.userable_type
      when 'Agent'
        s = "代理商"
      when 'Merchant'
        s = "商户"
    end

    case user.audit  #帐号是否审核通过
      when 'verifing'
        user.errors.add(:error, "#{s}审核中，暂时不能登录")
        return render_401(user)
      when 'reject'
        user.errors.add(:error, "#{s}审核失败，请联系您的服务商负责人")
        return render_401(user)
    end

    if user.is_disabled
      user.errors.add(:error, "该用户已被禁用")
      return render_401(user)
    end

    if user.authenticate(password)
      generate_jwt_by_login_name(login_name)
      render status: 200, json: user, serializer: UserSerializer
    else
      user.errors.add(:err_message, "账户名或密码错误")
      return render_401(user)
    end
  end

  ######################################################################################################################

  #更新个人资料
  #put /v1/accounts/:id/profile
  def update_profile
    #自己只能更新自己的
    authorize @user
    parameters = update_profile_params
    if @user.update(parameters)
      render status: 200
    else
      render_422(@user)
    end

  end

  #修改个人密码
  #put /v1/accounts/:id/password
  def modify_password
    #自己只能更新自己的
    authorize @user
    parameters = modify_password_params
    #验证原密码
    unless @user.authenticate(parameters[:original_password])
      @user.errors.add(:error, "原密码不正确")
      return render_422(@user)
    end
    if @user.update(parameters.except(:original_password))
      render status: 200
    else
      render_422(@user)
    end
  end


  private

  def create_params
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:login_name, :name, :description,
                                                         :role_id, :department_id, :role_id, :password])
    parameters[:password_confirmation] = parameters[:password]
    parameters
  end

  def update_params
    #如果字段没有修改，则前端传null值过来
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:login_name, :name, :description,
                                                              :department_id, :role_id])
    parameters.except!(:name) unless parameters[:name]
    parameters.except!(:login_name) unless parameters[:login_name]
    parameters.except!(:description) unless parameters[:description]
    parameters.except!(:department_id) unless parameters[:department_id]
    parameters.except!(:role_id) unless parameters[:role_id]
    parameters
  end

  def update_profile_params
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:avatar, :name, :login_name, :contact_phone])
    if parameters[:avatar].present?
      parameters[:avatar] = adapt_to_base64(parameters[:avatar])
    else
      parameters.except!(:avatar)
    end
    parameters.except!(:name) unless parameters[:name]
    parameters.except!(:description) unless parameters[:description]
  end

  def reset_password_params
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:password])
    parameters[:password_confirmation] = parameters[:password]
    parameters
  end

  def modify_password_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:original_password,
                                                                         :password, :password_confirmation])
  end

  def render_422(json)
    render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def render_401(json)
    render status: 401, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  #根据name生成jwt，并把jwt塞进响应头中
  def generate_jwt_by_login_name(login_name)
    exp = Time.now.to_i + 24*3600 # toke有效期为1天
    payload = {:login_name => login_name, :exp => exp}
    jwt = JsonWebToken.encode(payload)
    response.headers['Authorization'] = "Bearer #{jwt}"
  end

  def set_user
    @user = User.find_by(id: params[:id], is_deleted: false, is_disabled: false, audit: 'verified')
    return render status: 404 unless @user
    @user
  end

end
