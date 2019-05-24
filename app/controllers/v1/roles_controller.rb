class V1::RolesController < ApplicationController
  before_action :get_current_user
  before_action :get_role, only: [:show, :update, :destroy, :disable_role, :enable_role, :add_permissions]

  #查看各级平台相对应的角色
  #运营商平台，代理商或者商户添加用户时为用户赋予角色使用，没有分页
  #get /v1/relative_roles?
  def get_relative_roles
    #先判断当前用户有没有查看各级平台相对应的角色的权限
    authorize Role
    #判断当前用户是平台用户，代理商用户或者商户用户
    case @current_user.userable_type
      when "Platform"
        roles = Role.PLATFORM
      when "Agent"
        roles = Role.AGENT
      when "Merchant"
        roles = Role.MERCHANT
    end
    render status: 200, json: roles, each_serializer: RoleSerializer
  end

  #查看所有角色，有分页
  #get /v1/roles?page=xx&size=xx
  def index
    #先判断当前用户有没有查看各级平台相对应的角色的权限
    authorize Role
    page = params[:page]? params[:page] : 1
    roles = Role.where(is_deleted: false).order("org_type").order("level").page(page).per(params[:size])
    render status: 200, json: roles, meta: pagination_dict(roles),each_serializer: RoleInfoSerializer
  end

  #角色授权
  #先删除该角色所有的权限，然后重新添加权限
  #put /v1/roles/:id/permissions
  def add_permissions
    authorize Role
    permissions = get_permissions[:permissions]
    @role.delete_permissions
    @role.add_permissions(permissions)
    render status: 200
  end

  #查看角色
  #get /v1/roles/:id
  def show
    #验证当前用户有查看角色的权限
    authorize Role
    render status: 200, json: @role, serializer: RoleSerializer
  end

  #添加角色
  #post /v1/roles
  def create
    #验证当前用户有没有添加角色的权限
    authorize Role # binding.pry
    parameters = create_params
    role = Role.new(parameters)

    #验证当前角色所属的机构有没有相同的角色
    if Role.include?(parameters)
      role.errors.add(:error, "#{parameters[:org_type]}已经有了#{parameters[:name]}角色，不能重复创建！")
      return render_422(role)
    end

    if role.save
      render status: 201
    else
      return render_422(role)
    end
  end

  #更新角色
  #update /v1/roles/:id
  def update
    #验证当前用户有没有更新角色的权限
    authorize Role
    parameters = update_params
    return render status: 422 unless parameters
    if @role.update(parameters)
      render status: 200
    else
      render status: 422, json: @role, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  #停用角色
  #update /v1/roles/:id/disable_role
  def disable_role
    #权限验证
    authorize Role
    if @role.update(is_disabled: true)
      render status: 200
    else
      render_422(@role)
    end
  end

  #启用角色
  #update /v1/roles/:id/enable_role
  def enable_role
    #权限验证
    authorize Role
    if @role.update(is_disabled: false)
      render status: 200
    else
      render_422(@role)
    end
  end

  #删除角色
  #delete /v1/roles/:id
  def destroy
    #验证当前用户有没有删除角色的权限
    authorize Role
    @role.update(is_deleted: true)
    render status: 204
  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :description, :org_type, :level])
  end

  def update_params
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :description,
                                                                                      :org_type, :level])
    parameters.except!(:name) unless parameters[:name]
    parameters.except!(:description) unless parameters[:description]
    parameters.except!(:org_type) unless parameters[:org_type]
    parameters.except!(:level) unless parameters[:level]
    parameters
  end

  def get_permissions
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:permissions])
  end

  def get_role
    @role = Role.find_by(id: params[:id], is_deleted: false)
    return render status: 404 unless @role
  end

  def render_422(json)
    render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end

end
