class AddShortNameToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :short_name, :string, comment: "商户简称"
    add_column :merchants, :audit, :integer, default: 1, comment: "商户审核状态，1审核中，2审核通过，3审核失败"
    add_column :merchants, :is_disabled, :boolean, default: true, comment: "商户是否被禁用，false没有被禁用，true被禁用"
    add_column :merchants, :server_id, :uuid, index: true, comment: "维护这个商户的负责人id"
  end
end
