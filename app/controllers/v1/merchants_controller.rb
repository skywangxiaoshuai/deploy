class V1::MerchantsController < ApplicationController
  include Utilities
  before_action :get_current_user

  #根据name模糊查询
  #get /v1/merchants/search?q=123
  def search_by_name
    # authorize Merchant
    merchants = Merchant.ransack(name_cont: params[:q]).result
    render json: merchants
  end

  #post /v1/merchants
  def create
    #验证当前用户有没有添加代理商的权限
    authorize Merchant
    #取出当前用户的代理商信息
    agent = @current_user.userable
    parameters = merchant_params
    parameters[:server_id] = @current_user.id
    merchant = agent.merchants.new(parameters)
    if merchant.save
      #查出商户管理员角色
      role = Role.find_by(level: 0, org_type: 3)
      user = merchant.users.where(is_admin: true).first
      user.roles << role #为用户添加代理商管理员的角色
      render status: 201
    else
      render_422(merchant)
    end
  end

  private

    def merchant_params
      parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :short_name, :brand_name,
                                                                                        :brand_logo, :users_attributes])
      parameters[:brand_logo] = adapt_to_base64(parameters[:brand_logo]) if parameters[:brand_logo].present?
      parameters[:audit] = 'verified'
      parameters[:users_attributes][0][:audit] = 'verified'
      parameters[:users_attributes][0][:password_confirmation] = parameters[:users_attributes][0][:password]
      parameters[:users_attributes][0][:is_admin] = true
      parameters
    end

    def render_422(json)
      return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
    end
end
