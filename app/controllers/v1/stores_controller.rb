class V1::StoresController < ApplicationController
  include Utilities
  before_action :get_current_user
  before_action :set_store, only: [:create_user, :get_store_by_id, :update_store]
  before_action :get_store_user, only: [:get_store_user_by_id, :update_store_user]

  #查看门店店员信息(商户管理员权限)
  #get /v1/store_users/:id
  def get_store_user_by_id
    authorize Department
    render json: @store_user, serializer: StoreUserSerializer
  end

  #修改门店店员信息(商户管理员权限)
  #put /v1/store_users/:id
  def update_store_user
    authorize Department
    parameters = update_store_user_params
    if parameters[:store_id].present?
      @store_user.update(department_id: parameters[:store_id])
    end
    if parameters[:role_ids].present?
      @store_user.roles.delete_all
      parameters[:role_ids].each do |role_id|
        role = Role.find_by(id: role_id)
        @store_user.roles << role
      end
    end
    head(200)
  end

  #返回商户的门店列表（商户管理员权限或店长店员权限）
  #get /v1/stores
  def index_stores
    authorize Department
    role_name = @current_user.roles.pluck(:name)
    merchant = @current_user.userable
    if role_name.include?("管理员")
      stores = merchant.departments.where(is_store: true)
    else
      stores = Department.where(id: @current_user.department_id)
    end
    render json: stores, each_serializer: StoreSerializer
  end

  #查看门店信息(商户管理员权限或店长店员权限)
  #get /v1/stores/:id
  def get_store_by_id
    authorize Department
    if @current_user.roles.pluck(:org_type, :level).include?(["merchant", "admin"])
      if @current_user.userable.try(:id) != @store.departmentable.id
        return head(403)
      end
    else
      if @current_user.department.id != @store.id
        return head(403)
      end
    end
    # if @current_user.userable.try(:id) != @store.departmentable.id || @current_user.department.id == @store.id
    #   return head(403)
    # end
    render json: @store, serializer: StoreSerializer
  end

  #修改门店信息(商户管理员权限)
  #put /v1/stores/:id
  def update_store
    authorize @store
    @store.materials.delete_all
    if @store.update(store_params)
      head(200)
    else
      render_422@store
    end

  end

  #为某个门店添加店员(商户管理员权限)
  #post /v1/stores/:id/users
  def create_user
    authorize @store
    parameters = create_user_params
    role_ids = parameters[:role_ids]
    user = @store.users.new(parameters.except(:role_id))
    if user.save
      role_ids.each do |role_id|
        role = Role.find_by(id: role_id)
        user.roles << role
      end
      head(201)
    else
      render_422(user)
    end
  end

  #店员列表（商户管理员权限）
  #get /v1/stores_users
  def index_stores_users
    authorize Department
    merchant = @current_user.userable
    # binding.pry
    users = User.joins(:department)
                .joins("INNER JOIN merchants on departments.departmentable_id = merchants.id and departments.departmentable_type = 'Merchant'")
                .merge(Department.where(is_store: true))
                .distinct
    # users = User.joins(department: :merchant).where("merchants.id = ?", merchant.id).merge(Department.where(is_store: true))
    # users = merchant.departments.where(is_store: true).collect(&:users).flatten.uniq
    render json: users, each_serializer: StoreUserSerializer
  end

  #post /v1/stores
  def create_store
    #验证当前用户有没有添加门店的权限
    authorize Department
    #取出当前用户的商户信息
    merchant = @current_user.userable
    parameters = store_params
    store = merchant.departments.new(parameters)
    if store.save
      render status: 201
    else
      render_422(store)
    end
  end



  private

    def store_params
      parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :description,
                          :address, :contact_phone, :materials_attributes])
      parameters[:is_store] = true
      if parameters[:materials_attributes].present?
        parameters[:materials_attributes].each do |m|
          m[:picture] = adapt_to_base64(m[:picture])
        end
      end
      parameters
    end

    def create_user_params
      parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :login_name,
                                                                    :contact_phone, :role_ids, :password])
      parameters[:password_confirmation] = parameters[:password]
      parameters
    end

    def update_store_user_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:role_ids, :store_id])
    end

    def render_422(json)
      return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
    end

    def set_store
      @store = Department.find_by(id: params[:id], is_store: true)
      return head(404) unless @store
    end

    def get_store_user
      @store_user = User.find_by(id: params[:id])
      return head(404) unless @store_user
    end
end
