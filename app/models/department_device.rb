class DepartmentDevice < ApplicationRecord
  # belongs_to :department
  # belongs_to :device

  validates :device_id, presence: {message: "序列号不能为空"}
  validates :acknowledgment, length: {maximum: 20, message: "长度不能超过20"}
  validates :department_id, presence: {message: "门店id不能为空"}
  validate :bind_device_validate, on: :create

  # after_create :active_device
  after_destroy :unactive_device

  private

  def bind_device_validate
    device = Device.find_by(id: device_id)
    if device.nil?
      errors.add(:device_id, "序列号不存在")
      return
    end
    if device.activated
      errors.add(:device_id, "该设备号已经被使用")
    end
    department_device = DepartmentDevice.find_by(device_id: device_id, department_id: department_id)
    if department_device
      errors.add(:device_id, "该门店已经绑定了该设备")
    end
  end

  def active_device
    device = Device.find_by(id: device_id)
    device.update(activated: true)
  end

  def unactive_device
    device = Device.find_by(id: device_id)
    device.update(activated: false)
  end

end
