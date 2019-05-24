class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :enabled, :contact_phone, :qrcode_url, :materials

  def qrcode_url
    "https://www.yapos.cn/example?sid=#{object.id}"
  end

  def materials
    object.materials.map{ |material| {name: material.name, picture: material.picture}}
  end
end
