class PaymentHeliAccountApplication < ApplicationRecord

  has_and_belongs_to_many :materials, join_table: :payment_heli_account_applications_materials

  belongs_to :merchant

  has_one :payment_account, as: :payment_accountable
end
