# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#创建一个平台管理员角色,并赋予权限
r1 = Role.create(name: "管理员", org_type: "platform", level: 0, description: "平台管理员")
r2 = Role.create(name: "管理员", org_type: "agent", level: 0, description: "代理商管理员")
r3 = Role.create(name: "管理员", org_type: "merchant", level: 0, description: "商户管理员")
r4 = Role.create(name: "店长", org_type: "merchant", level: 3, description: "门店店长")
r5 = Role.create(name: "店员", org_type: "merchant", level: 3, description: "门店店员")
pr = Role.create(name: "管理员", org_type: "platform", level: 1, description: "平台管理员")
Permission.create(short_name: "添加角色", full_name: "添加角色")
pr_permissions = Permission.pluck(:id)
pr_permissions.each do |permission|
  pr.roles_permissions.create(permission_id: permission)
end

Platform.create(name: "上海维浦信息技术有限公司")
platform = Platform.first
user = platform.users.new(name: platform.name, login_name: "admin", password: "12345678",
                          password_confirmation: "12345678", audit: 2, is_admin: true)
user.save!
user.roles << pr

导入商户类型
require 'csv'
csv_text = File.read(Rails.root.join('lib', 'seed', 'category.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1:UTF-8')
csv.each do |row|
  m = Category.new
  m.id = row['id']
  m.parent_id = row['parent_id']
  m.name = row['name']
  m.save
end
#
# puts "#{Category.count} rows are seeded"
