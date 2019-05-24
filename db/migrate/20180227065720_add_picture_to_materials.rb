class AddPictureToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_attachment :materials, :picture, comment: "资料图片地址"
  end
end
