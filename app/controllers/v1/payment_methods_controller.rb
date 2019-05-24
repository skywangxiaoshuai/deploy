class V1::PaymentMethodsController < ApplicationController
  before_action :get_current_user

  #get /v1/payment_methods
  def index
    authorize PaymentMethod
    payment_methods = PaymentMethod.all
    render status: 200, json: payment_methods, each_serializer: PaymentMethodSerializer
  end

  #post /v1/payment_methods
  def create
    authorize PaymentMethod
    payment_method = PaymentMethod.new(create_params)
    if payment_method.save
      render status: 201
    else
      render_422(payment_method)
    end
  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:name, :description])
  end

  def render_422(json)
    return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
