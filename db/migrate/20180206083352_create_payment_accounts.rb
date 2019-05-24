class CreatePaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_accounts, id: :uuid do |t|
      t.integer :status
      t.uuid :merchant_id
      t.references :payment_accountable, polymorphic: true, index: {name: "index_other"}, type: :uuid

      t.timestamps
    end
    add_index :payment_accounts, :merchant_id
  end
end
