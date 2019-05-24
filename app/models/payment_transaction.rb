class PaymentTransaction < ApplicationRecord
  #"business_type", comment: "业务类型，交易1，退款2，扣除交易手续费3，退回交易手续费4"
  #"income_expenses_type", comment: "收支类型，1收入，2支出"
  belongs_to :store, class_name: "Department"
  belongs_to :merchant
end
