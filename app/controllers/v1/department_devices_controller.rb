class V1::DepartmentDevicesController < ApplicationController
  before_action :get_current_user
  before_action :set_store, only: [:bind_device, :index_devices]
  before_action :set_device, only: [:unbind_device]

  #门店绑定设备，一个门店可以绑定多个设备，但是不能多次绑定同一个设备(商户管理员、店长、店员权限)
  #post /v1/stores/:id/store_devices
  def bind_device
    authorize @store
    parameters = bind_device_params.merge({department_id: @store.id})
    store_device = DepartmentDevice.new(parameters)
    if store_device.save
      head(201)
    else
      render_422(store_device)
    end
  end

  #设备列表(商户管理员、店长、店员权限)
  #get /v1/stores/:id/store_devices
  def index_devices
    authorize @store
    store_devices = DepartmentDevice.where("department_id = ?", @store.id)
    render json: store_devices, each_serializer: DepartmentDeviceSerializer
  end

  #解绑设备(商户管理员、店长、店员权限)
  #delete /v1/store_devices/:id
  def unbind_device
    store = Department.find_by(id: @department_device.department_id)
    authorize store
    @department_device.destroy
    head(204)
  end

  private

    def bind_device_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:device_id, :acknowledgment])
    end

    def set_store
      @store = Department.find_by(id: params[:id], is_store: true)
      return head(404) unless @store
    end

    def render_422(json)
      return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
    end

    def set_device
      @department_device = DepartmentDevice.find_by(id: params[:id])
      return head(404) unless @department_device
    end
end
