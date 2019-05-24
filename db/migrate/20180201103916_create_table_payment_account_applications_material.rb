class CreateTablePaymentAccountApplicationsMaterial < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_alipay_account_applications_materials, id: false do |t|
      t.references :payment_alipay_account_application, type: :uuid, index: {:name => "index_alipay"}
      t.references :material, type: :uuid, index: {:name => "index_alipay_material"}
    end

    create_table :payment_wechat_account_applications_materials, id: false do |t|
      t.references :payment_wechat_account_application, type: :uuid, index: {:name => "index_wechat"}
      t.references :material, type: :uuid, index: {:name => "index_wechat_material"}
    end

    create_table :payment_heli_account_applications_materials, id: false do |t|
      t.references :payment_heli_account_application, type: :uuid, index: {:name => "index_heli"}
      t.references :material, type: :uuid, index: {:name => "index_heli_material"}
    end
  end
end
