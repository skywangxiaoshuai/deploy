class Device < DeviceBase
  self.primary_key = :id

  # has_many :department_devices
  # has_many :departments, through: :department_devices
end
