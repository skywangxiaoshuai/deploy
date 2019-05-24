class V1::PaymentAccountsController < ApplicationController
  before_action :get_current_user

  #返回商户账户列表
  #get /v1/payment_accounts?page=1&size=2
  def index
    authorize PaymentAccount
    page = params[:page]? params[:page] : 1
    payment_accounts = PaymentAccount.all.page(page).per(params[:size])
    render json: payment_accounts, meta: pagination_dict(payment_accounts)
  end

  #添加商户账户
  #post /v1/payment_accounts
  def create
    authorize PaymentAccount
    parameters = create_params
    payment_account = PaymentAccount.new(parameters)

    if payment_account.save
      render status: 201
    else
      render_422(payment_account)
    end

  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :channel_id, :account, :merchant_id, :rate])
  end

  def render_422(json)
    return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
