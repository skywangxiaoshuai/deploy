class AddSomeColumnsToAgents < ActiveRecord::Migration[5.1]
  def change
    add_column :agents, :agent_type, :integer, comment: "代理商类型，1企业，2个人"
    add_column :agents, :short_name, :string, comment: "代理商简称"

    # add_column :agents, :reg_number, :string, comment: "企业注册号"
    # add_column :agents, :reg_name, :string, comment: "企业注册名称"
    # add_column :agents, :reg_address, :string, comment: "企业注册地址"
    # add_column :agents, :reg_operating_period, :string, array: true, length: 2, comment: "企业营业期限"
    # add_column :agents, :reg_business_scope, :text, comment: "企业经营范围"
    #
    # add_column :agents, :artificial_person_name, :string, comment: "法人姓名"
    # add_column :agents, :artificial_person_ID_type, :integer, comment: "法人证件类型,1身份证，2护照"
    # add_column :agents, :artificial_person_ID_number, :string, comment: "法人证件号码"
    # add_column :agents, :artificial_person_ID_valid_date, :datetime, comment: "法人证件有效期"
    #
    # add_column :agents, :CATP, :integer, comment: "账户类型：1对公账户, 2法人账户"
    # add_column :agents, :deposit_bank, :string, comment: "开户银行"
    # add_column :agents, :bank_card_name, :string, comment: "银行户名"
    # add_column :agents, :bank_card_number, :string, comment: "银行卡号"
    #
    # add_column :agents, :district, :jsonb, comment: "所在地区"
    # add_column :agents, :detailed_address, :string, comment: "详细地址"
    #
    # add_column :agents, :contact_name, :string, comment: "联系人姓名"
    # add_column :agents, :contact_phone, :string, comment: "联系人电话"
    # add_column :agents, :contact_email, :string, comment: "联系人邮箱"


  end
end
