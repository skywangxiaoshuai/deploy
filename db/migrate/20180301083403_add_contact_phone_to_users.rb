class AddContactPhoneToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :contact_phone, :string, comment: "联系电话"
  end
end
