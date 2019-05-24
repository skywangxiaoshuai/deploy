class DeviceBase < ActiveRecord::Base
  #我们为需要连接其他数据库的Model定义出父类
  #该类只是供其他Model继承，将这个类设定为抽象类，并没有具体的数据库表对应
  #如果不设置，ActiveRecord会从数据库寻找对应的表，如果找不到，会报错
  self.abstract_class = true

  #使用指定的配置连接数据库
  establish_connection("device_db_#{Rails.env}".to_sym)

end
