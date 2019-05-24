class AddColumnsToAgents < ActiveRecord::Migration[5.1]
  def change
    add_column :agents, :is_deleted, :boolean, default: false, comment: "标记该代理商是否被删除"
    add_column :agents, :is_disabled, :boolean, default: false, comment: "标记该代理商是否被禁用"
    add_column :agents, :server_id, :uuid, index: true, comment: "记录运营平台的哪个人负责该代理商的业务"
    add_column :agents, :audit, :integer, index: true, comment: "审核状态：1审核中，2审核通过，3审核失败"
    add_column :agents, :reject_reason, :string, comment: "审核失败原因"

  end
end
