class V1::PaymentMethodChannelsController < ApplicationController
  before_action :get_current_user

  #返回商户支付方式列表(商户管理员权限)
  #get /v1/payment_method_channels
  def index
    authorize PaymentMethodChannel
    merchant = @current_user.userable
    payment_method_channels = merchant.payment_method_channels
    render json: payment_method_channels
  end

  #商户配置自己的支付方式及通道
  #post /v1/payment_method_channels
  def create
    authorize PaymentMethodChannel
    #取出当前用户的商户信息(只有商户管理员可以做此操作)
    parameters = create_params
    merchant = @current_user.userable
    payment_method_name = PaymentMethod.find_by(id: parameters[:payment_method_id]).try(:name)
    payment_channel_name = PaymentChannel.find_by(id: parameters[:payment_channel_id]).try(:name)
    #从payment_accounts中取出该商户在该渠道下的rate
    rate = PaymentAccount.find_by(merchant_id: merchant.id, channel_id: parameters[:payment_channel_id]).try(:rate)
    params = {
        rate: rate,
        payment_method_name: payment_method_name,
        payment_channel_name: payment_channel_name
    }.merge(parameters)
    payment_method_channel = merchant.payment_method_channels.new(params)
    if payment_method_channel.save
      head(201)
    else
      render_422(payment_method_channel)
    end
  end

  private

    def create_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:payment_method_id, :payment_channel_id])
    end

    def render_422(json)
      return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
    end
end
