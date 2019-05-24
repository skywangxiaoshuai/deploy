# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180304040452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "platform_id"
    t.boolean "is_deleted", default: false, comment: "标记该代理商是否被删除"
    t.boolean "is_disabled", default: false, comment: "标记该代理商是否被禁用"
    t.uuid "server_id", comment: "记录运营平台的哪个人负责该代理商的业务"
    t.integer "audit", comment: "审核状态：1审核中，2审核通过，3审核失败"
    t.string "reject_reason", comment: "审核失败原因"
    t.integer "agent_type", comment: "代理商类型，1企业，2个人"
    t.string "short_name", comment: "代理商简称"
    t.index ["platform_id"], name: "index_agents_on_platform_id"
  end

  create_table "categories", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "department_devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "acknowledgment", comment: "门店针对每个设备可以设置不同的答谢语"
    t.uuid "department_id", comment: "department外键"
    t.string "device_id", comment: "device外键"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_devices_on_department_id"
    t.index ["device_id"], name: "index_department_devices_on_device_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", comment: "部门名称"
    t.integer "department_type", comment: "1职能部门，2业务部门"
    t.boolean "is_store", default: false, comment: "用于标记该部门是不是门店"
    t.string "departmentable_type"
    t.uuid "departmentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", comment: "简介"
    t.string "address", comment: "详细地址"
    t.string "contact_phone", comment: "联系电话"
    t.boolean "enabled", default: true, comment: "是否启用"
    t.index ["departmentable_type", "departmentable_id"], name: "index_departments_on_departmentable_type_and_departmentable_id"
  end

  create_table "materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "materialable_type"
    t.uuid "materialable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name", comment: "资料图片地址"
    t.string "picture_content_type", comment: "资料图片地址"
    t.integer "picture_file_size", comment: "资料图片地址"
    t.datetime "picture_updated_at", comment: "资料图片地址"
    t.index ["materialable_type", "materialable_id"], name: "index_materials_on_materialable_type_and_materialable_id"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "agent_id"
    t.string "short_name", comment: "商户简称"
    t.integer "audit", default: 1, comment: "商户审核状态，1审核中，2审核通过，3审核失败"
    t.boolean "is_disabled", default: true, comment: "商户是否被禁用，false没有被禁用，true被禁用"
    t.uuid "server_id", comment: "维护这个商户的负责人id"
    t.string "brand_name", comment: "品牌名称"
    t.string "brand_logo_file_name", comment: "品牌logo"
    t.string "brand_logo_content_type", comment: "品牌logo"
    t.integer "brand_logo_file_size", comment: "品牌logo"
    t.datetime "brand_logo_updated_at", comment: "品牌logo"
    t.index ["agent_id"], name: "index_merchants_on_agent_id"
  end

  create_table "payment_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status"
    t.uuid "merchant_id"
    t.string "payment_accountable_type"
    t.uuid "payment_accountable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account"
    t.float "rate"
    t.string "ali_auth_token", comment: "支付宝商户授权令牌，服务商代商户发起支付时使用"
    t.string "ali_refresh_token", comment: "刷新令牌，用于刷新ali_auth_token"
    t.string "name", comment: "账户名称"
    t.integer "channel_id", comment: "通道id"
    t.boolean "enabled", default: true, comment: "商户账户是否启用"
    t.index ["merchant_id"], name: "index_payment_accounts_on_merchant_id"
    t.index ["payment_accountable_type", "payment_accountable_id"], name: "index_other"
  end

  create_table "payment_alipay_account_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "merchant_id"
    t.string "pid", comment: "支付宝商户pid，2088开头"
    t.index ["merchant_id"], name: "index_payment_alipay_account_applications_on_merchant_id"
    t.index ["pid"], name: "index_payment_alipay_account_applications_on_pid"
  end

  create_table "payment_alipay_account_applications_materials", id: false, force: :cascade do |t|
    t.uuid "payment_alipay_account_application_id"
    t.uuid "material_id"
    t.index ["material_id"], name: "index_alipay_material"
    t.index ["payment_alipay_account_application_id"], name: "index_alipay"
  end

  create_table "payment_channel_methods", id: false, force: :cascade do |t|
    t.integer "payment_channel_id"
    t.integer "payment_method_id"
    t.index ["payment_channel_id"], name: "index_payment_channel_methods_on_payment_channel_id"
    t.index ["payment_method_id"], name: "index_payment_channel_methods_on_payment_method_id"
  end

  create_table "payment_channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", comment: "支付通道描述"
    t.string "rate", comment: "支付通道费率范围描述"
    t.text "application_material", comment: "申请支付通道所需资料"
    t.boolean "enabled", comment: "支付通道是否启用"
  end

  create_table "payment_heli_account_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "merchant_id"
    t.index ["merchant_id"], name: "index_payment_heli_account_applications_on_merchant_id"
  end

  create_table "payment_heli_account_applications_materials", id: false, force: :cascade do |t|
    t.uuid "payment_heli_account_application_id"
    t.uuid "material_id"
    t.index ["material_id"], name: "index_heli_material"
    t.index ["payment_heli_account_application_id"], name: "index_heli"
  end

  create_table "payment_method_channels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "rate"
    t.integer "payment_method_id"
    t.integer "payment_channel_id"
    t.uuid "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method_name"
    t.string "payment_channel_name"
    t.boolean "enabled", default: true
    t.index ["merchant_id"], name: "index_payment_method_channels_on_merchant_id"
    t.index ["payment_channel_id"], name: "index_payment_method_channels_on_payment_channel_id"
    t.index ["payment_method_id"], name: "index_payment_method_channels_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", comment: "支付方式描述"
    t.boolean "enabled", default: true, comment: "是否启用,true为启用 false为禁用"
  end

  create_table "payment_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "merchant_trade_no", comment: "商户订单号"
    t.integer "payment_channel_id", comment: "支付通道id"
    t.integer "payment_method_id", comment: "支付方式id"
    t.float "rate", comment: "费率"
    t.string "channel_transaction_id", comment: "渠道方交易流水号"
    t.string "consumer_id", comment: "消费者标识"
    t.string "merchant_no", comment: "商户号"
    t.string "trade_type", comment: "交易类型"
    t.string "bank_type", comment: "银行类型"
    t.integer "total_amount", comment: "总金额，单位是分"
    t.integer "status", comment: "订单状态，1支付成功，2支付失败，3未支付，4订单已关闭，5订单已撤销，6订单已退款，7订单状态未知"
    t.string "merchant_refund_no", comment: "商户退款单号"
    t.integer "refund_amount", comment: "退款金额，单位是分"
    t.integer "refund_status", comment: "退款状态, 1退款成功，2退款失败"
    t.uuid "user_id", comment: "门店店员id"
    t.uuid "store_id", comment: "门店外键"
    t.uuid "merchant_id", comment: "商户外键"
    t.integer "receipt_amount", comment: "实收金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_payment_orders_on_merchant_id"
    t.index ["merchant_no"], name: "index_payment_orders_on_merchant_no"
    t.index ["merchant_trade_no"], name: "index_payment_orders_on_merchant_trade_no"
    t.index ["refund_status"], name: "index_payment_orders_on_refund_status"
    t.index ["status"], name: "index_payment_orders_on_status"
    t.index ["store_id"], name: "index_payment_orders_on_store_id"
  end

  create_table "payment_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "merchant_trade_no", comment: "商户订单号"
    t.uuid "merchant_id", comment: "商户外键"
    t.integer "business_type", comment: "业务类型，交易1，退款2，扣除交易手续费3，退回交易手续费4"
    t.integer "income_expenses_type", comment: "收支类型，1收入，2支出"
    t.integer "payment_channel_id", comment: "支付通道id"
    t.integer "payment_method_id", comment: "支付方式id"
    t.uuid "store_id", comment: "门店外键"
    t.integer "amount", comment: "流水金额"
    t.string "channel_transaction_id", comment: "渠道方交易流水号"
    t.index ["channel_transaction_id"], name: "index_payment_transactions_on_channel_transaction_id"
    t.index ["merchant_id"], name: "index_payment_transactions_on_merchant_id"
    t.index ["store_id"], name: "index_payment_transactions_on_store_id"
  end

  create_table "payment_wechat_account_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "merchant_id"
    t.index ["merchant_id"], name: "index_payment_wechat_account_applications_on_merchant_id"
  end

  create_table "payment_wechat_account_applications_materials", id: false, force: :cascade do |t|
    t.uuid "payment_wechat_account_application_id"
    t.uuid "material_id"
    t.index ["material_id"], name: "index_wechat_material"
    t.index ["payment_wechat_account_application_id"], name: "index_wechat"
  end

  create_table "permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "short_name", comment: "权限的简称，用于前端直接拿去显示"
    t.string "full_name", comment: "权限的全称，用于后端判断接口权限"
    t.uuid "parent_id"
    t.integer "level", comment: "代表该权限是几级菜单"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_permissions_on_parent_id"
  end

  create_table "platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", comment: "角色名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", comment: "角色等级：1公司领导，2部门领导，3一线员工"
    t.boolean "is_deleted", default: false, comment: "用于标记该角色是否被删除"
    t.uuid "parent_id"
    t.string "description", comment: "角色描述"
    t.integer "org_type", comment: "角色所属机构类型，1平台，2代理商，3商户"
    t.boolean "is_disabled", default: false, comment: "是否被停用"
    t.index ["level"], name: "index_roles_on_level"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["parent_id"], name: "index_roles_on_parent_id"
  end

  create_table "roles_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "permission_id"
    t.uuid "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_roles_permissions_on_permission_id"
    t.index ["role_id"], name: "index_roles_permissions_on_role_id"
  end

  create_table "stores_materials", id: false, force: :cascade do |t|
    t.uuid "store_id"
    t.uuid "material_id"
    t.index ["material_id"], name: "index_stores_materials_on_material_id"
    t.index ["store_id"], name: "index_stores_materials_on_store_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "login_name"
    t.string "password_digest"
    t.string "description"
    t.uuid "parent_id"
    t.string "userable_type"
    t.uuid "userable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_disabled", default: false, comment: "标记该用户是否启用"
    t.integer "audit", default: 2, comment: "审核状态：1审核中，2审核通过，3审核失败"
    t.boolean "is_admin", default: false, comment: "标记该用户是不是对应平台的最初管理员"
    t.uuid "department_id", comment: "department的外键"
    t.boolean "is_deleted", default: false, comment: "标记该用户是否被删除"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "contact_phone", comment: "联系电话"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["is_deleted"], name: "index_users_on_is_deleted"
    t.index ["parent_id"], name: "index_users_on_parent_id"
    t.index ["userable_type", "userable_id"], name: "index_users_on_userable_type_and_userable_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
