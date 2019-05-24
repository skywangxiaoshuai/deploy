class AddStoreIdToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :payment_transactions, :store, type: :uuid, index: true, comment: "门店外键"
  end
end
