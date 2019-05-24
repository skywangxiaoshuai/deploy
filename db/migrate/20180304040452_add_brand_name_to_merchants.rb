class AddBrandNameToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :brand_name, :string, comment: "品牌名称"
    add_attachment :merchants, :brand_logo, comment: "品牌logo"
  end
end
