class PaymentOrder < ApplicationRecord
  #订单状态，1支付成功，2支付失败，3未支付，4订单已关闭，5订单已撤销，6订单已退款，7订单状态未知, 8退款中
  enum status: {SUCCESS: 1, FAIL: 2, NOTPAY: 3, CLOSED: 4, REVOKED: 5, REFUNDED: 6, UNKNOWN: 7, REFUNDING: 8, USERPAYING: 9}

  #退款状态, 1退款成功，2退款失败, 3退款中
  enum refund_status: {REFUND_SUCCESS:1, REFUND_FAIL:2, IN_HAND: 3}
  belongs_to :store, class_name: "Department"
  belongs_to :merchant
end
