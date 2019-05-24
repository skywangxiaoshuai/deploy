class V1::PaymentChannelsController < ApplicationController
  before_action :get_current_user
  before_action :set_payment_channel, only: [:configurate_channel]
  before_action :set_payment_method, only: [:get_payment_method_channels]

  #返回某个支付方式所对应的通道(商户添加支付方式时使用)
  #get /v1/payment_methods/:id/payment_channels
  def get_payment_method_channels
    authorize PaymentChannel
    payment_channels = @payment_method.payment_channels
    render json: payment_channels
  end

  #返回所有支付通道
  #get /v1/payment_channels
  def index
    authorize PaymentChannel
    payment_channels = PaymentChannel.all
    render json: payment_channels, fields: [:name]
  end

  #post /v1/payment_channels
  def create
    authorize PaymentChannel
    payment_channel = PaymentChannel.new(create_params)
    if payment_channel.save
      render status: 201
    else
      render_422(payment_channel)
    end
  end

  #配置支付通道所支持的支付方式
  #post /v1/payment_channel/:id/payment_methods
  def configurate_channel
    authorize PaymentChannel
    parameters = configurate_channel_params
    PaymentChannel.transaction do
      @payment_channel.payment_methods.delete_all
      parameters[:payment_methods].each do |method_id|
        method = PaymentMethod.find(method_id)
        @payment_channel.payment_methods << method
      end
    end
    render status: 201
  end

  private

    def create_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :description, :rate, :application_material])
      .merge({enabled: true})
    end

    def configurate_channel_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:payment_methods])
    end

    def render_422(json)
      return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
    end

    def set_payment_channel
      @payment_channel = PaymentChannel.find_by(id: params[:id])
      return render status: 404 unless @payment_channel
    end

    def set_payment_method
      @payment_method = PaymentMethod.find_by(id: params[:id])
      return render status: 404 unless @payment_method
    end
end
