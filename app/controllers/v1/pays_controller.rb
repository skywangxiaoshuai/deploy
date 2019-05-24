class V1::PaysController < ApplicationController
  include Utilities
  before_action :get_current_user, only: [:make_collections, :refund]

  #商户主扫收款
  #post /v1/stores/gathering
  def make_collections
    # #统一封装收款结果，作为该接口的返回值
    # success_json = {
    #     result: "SUCCESS",
    #     total_amount: 0,
    #     transaction_id: "",
    #     merchant_trade_no: ""
    # }
    # fail_json = {
    #     result: "FAIL",
    #     err_message: ""
    # }
    parameters = make_collections_params
    #TODO检查该门店是否营业，该门店所属的商户是否能正常使用支付服务,如果检查通过，再进行后续的操作
    store = Department.find_by(id: parameters[:sid], is_store: true) #必须是门店才能进行后续的操作
    return render status: 404 unless store
    merchant = store.departmentable
    #TODO门店及所属商户的各种状态检查, 检查通过才能进行后续操作
    # if store.is_disabled || merchant.is_disabled
    #   return render status: 403
    # end

    #先判断auth_code是微信的还是支付宝的
    method = Pay.judge_payment_method(parameters[:auth_code])
    if method == "wechat"
      #检查商户有没有微信支付这个方式，再查看该方式使用的那个通道
      payment_method = merchant.payment_method_channels.find_by(payment_method_name: "微信支付")
      unless payment_method
        return render status: 403
      end
      #查出商户为该支付方式配置的通道
      payment_channel_name = payment_method.payment_channel_name
      if payment_channel_name == "微信官方"
        #查出商户的商户号
        payment_account = merchant.payment_wechat_account_application.try(:payment_account)
        merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        #先创建商户订单
        order = store.payment_orders.new(merchant_trade_no: merchant_trade_no,
                                         payment_channel_id: payment_method.payment_channel_id,
                                         payment_method_id: payment_method.payment_method_id,
                                         rate: payment_account.try(:rate),
                                         merchant_no: payment_account.try(:account),
                                         total_amount: parameters[:total_amount],
                                         status: "NOTPAY",
                                         merchant_id: merchant.id,
                                         store_id: store.id,
                                         user_id: @current_user.id
        )
        unless order.save
          return render status: 422, json: response, serializer: ActiveModel::Serializer::ErrorSerializer
        end
        response = Pay.invoke_wechat_micropay(order, store, parameters[:auth_code])
        return render status: 200, json: response
      end

      if payment_channel_name == "其他"
        #TODO调用其他渠道接口进行支付
      end
    elsif method == "alipay"
      #检查商户有没有支付宝支付这个方式，再查看该方式使用的那个通道
      payment_method = merchant.payment_method_channels.find_by(payment_method_name: "支付宝支付")
      unless payment_method
        return render status: 403
      end
      #查出商户为该支付方式配置的通道
      payment_channel_name = payment_method.payment_channel_name
      if payment_channel_name == "支付宝官方"
        #TODO 调用支付宝官方的刷卡支付
        #查出商户的商户号
        payment_account = merchant.payment_alipay_account_application.try(:payment_account)
        merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        #先创建商户订单
        order = store.payment_orders.new(merchant_trade_no: merchant_trade_no,
                                         payment_channel_id: payment_method.payment_channel_id,
                                         payment_method_id: payment_method.payment_method_id,
                                         rate: payment_account.try(:rate),
                                         merchant_no: payment_account.try(:account),
                                         total_amount: parameters[:total_amount],
                                         status: "NOTPAY",
                                         merchant_id: merchant.id,
                                         store_id: store.id,
                                         user_id: @current_user.id
        )
        unless order.save
          return render status: 422, json: response, serializer: ActiveModel::Serializer::ErrorSerializer
        end
        data = Pay.invoke_alipay_trade_pay(order, store, parameters[:auth_code], payment_account.try(:ali_auth_token))
        return render status: 200, json: data
      end
      if payment_channel_name == "其他"
        #TODO 调用其他渠道进行支付支付
        return render status: 200
      end
    else
      response = {message: "不支持此付款"}
      return render status: 403, json: response
    end

  end

  #申请退款
  #post /v1/refund
  def refund
    #只有成功付款的订单才能退款
    parameters = refund_params
    order = PaymentOrder.find_by(merchant_trade_no: parameters[:merchant_trade_no], status: "SUCCESS")
    return render status: 404 unless order #如果订单不存在直接返回404
    authorize order
    #取出该订单的付款方式
    method_name = PaymentMethod.find_by(id: order.payment_method_id).name
    channel_name = PaymentChannel.find_by(id: order.payment_channel_id).name
    if method_name == "支付宝支付"
      #再判断该订单用的哪个通道
      if channel_name == "支付宝官方"
        #查出商户的授权token
        token = order.merchant.payment_alipay_account_application.payment_account.ali_auth_token
        response = Pay.invoke_alipay_refund(order, token)
      end
      if channel_name == "其他"
        #TODO 调用其他渠道的退款接口
      end
    end
    if method_name == "微信支付"
      if channel_name == "微信官方"
        #调用微信官方的退款接口
        response = Pay.invoke_wechat_rerund(order)
      end
      if channel_name == "其他"
        #调用其他渠道的退款接口
      end
    end
    render status: 200, json: response
  end

  #微信扫码付款(用户扫码，发起扫码支付)
  #params
  #  sid: 门店id
  #  total_amount: 总金额
  #post /v1/wechat_payment
  def wechat_payment
    parameters = payment_params
    #TODO检查该门店是否营业，该门店所属的商户是否能正常使用支付服务,如果检查通过，再进行后续的操作
    store = Department.find_by(id: parameters[:sid], is_store: true) #必须是门店才能进行后续的操作
    return render status: 404 unless store
    merchant = store.departmentable
    #TODO门店及所属商户的各种状态检查, 检查通过才能进行后续操作
    # if store.is_disabled || merchant.is_disabled
    #   return render status: 403
    # end

    #检查商户有没有微信支付这个方式，再查看该方式使用的那个通道
    payment_method = merchant.payment_method_channels.find_by(payment_method_name: "微信支付")
    unless payment_method
      return render status: 403
    end
    #查出商户为该支付方式配置的通道
    payment_channel_name = payment_method.payment_channel_name
    if payment_channel_name == "微信官方"
      #查出商户的商户信息
      payment_account = merchant.payment_wechat_account_application.try(:payment_account)
      merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
      #先创建商户订单
      order = store.payment_orders.new(merchant_trade_no: merchant_trade_no,
                                       payment_channel_id: payment_method.payment_channel_id,
                                       payment_method_id: payment_method.payment_method_id,
                                       rate: payment_account.try(:rate),
                                       merchant_no: payment_account.try(:account),
                                       total_amount: parameters[:total_amount],
                                       status: "NOTPAY",
                                       merchant_id: merchant.id,
                                       store_id: store.id
      )
      unless order.save
        return render status: 422, json: response, serializer: ActiveModel::Serializer::ErrorSerializer
      end
      #调用支付宝官方的扫码支付
      response = Pay.invoke_wechat_native_pay(order, store)
    end

    if payment_channel_name == "其他"
      #TODO调用其他渠道接口进行支付
    end
    render status: 200, json: response
  end

  #支付宝扫码付款（用户扫码，发起扫码支付）
  #params
  #  sid: 门店id
  #  total_amount: 总金额
  #post /v1/alipay_payment
  def alipay_payment
    # binding.pry
    parameters = payment_params
    #TODO检查该门店是否营业，该门店所属的商户是否能正常使用支付服务,如果检查通过，再进行后续的操作
    store = Department.find_by(id: parameters[:sid], is_store: true) #必须是门店才能进行后续的操作
    return render status: 404 unless store
    merchant = store.departmentable
    #TODO门店及所属商户的各种状态检查, 检查通过才能进行后续操作
    # if store.is_disabled || merchant.is_disabled
    #   return render status: 403
    # end

    #检查商户有没有微信支付这个方式，再查看该方式使用的那个通道
    payment_method = merchant.payment_method_channels.find_by(payment_method_name: "支付宝支付")
    unless payment_method
      return render status: 403
    end
    #查出商户为该支付方式配置的通道
    payment_channel_name = payment_method.payment_channel_name
    if payment_channel_name == "支付宝官方"
      #查出商户的商户信息
      payment_account = merchant.payment_alipay_account_application.try(:payment_account)
      merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
      #先创建商户订单
      order = store.payment_orders.new(merchant_trade_no: merchant_trade_no,
                                       payment_channel_id: payment_method.payment_channel_id,
                                       payment_method_id: payment_method.payment_method_id,
                                       rate: payment_account.try(:rate),
                                       merchant_no: payment_account.try(:account),
                                       total_amount: parameters[:total_amount],
                                       status: "NOTPAY",
                                       merchant_id: merchant.id,
                                       store_id: store.id
      )
      unless order.save
        return render status: 422, json: response, serializer: ActiveModel::Serializer::ErrorSerializer
      end
      #调用支付宝官方的扫码支付
      response = Pay.invoke_alipay_native_pay(order, store, payment_account.try(:ali_auth_token))
    end

    if payment_channel_name == "其他"
      #TODO调用其他渠道接口进行支付
    end
    render status: 200, json: response
  end

  #支付宝扫码支付结果异步通知
  #post /v1/alipay_payment/notification
  def alipay_payment_notification
    #先验签
    params = {
        "gmt_create" => "2018-02-22 13:04:47",
        "charset" => "utf-8",
        "seller_email" => "kaboxy@163.com",
        "subject" => "测试门店",
        "sign" => "f4D39FZc8+a0XNlcGOncaYIs7H+2jbYVg503rl/vckO0FHSYO7jbVog4au3Hcqlgh1puvtHjlMcwzg/jzPFolZVy6sYTcGZ5zQo6rgqNJfnK9ZpFQPmA/STpsvLTx3+3ETx9ocAorQhbjkl0MGWx6itwvfcBP6ZxhRvJ2oF5yO81RBsaacgn5xIvo+SpJ3pZK1YYOB5be/v6h+YeKIklc4gzcRMhEVjqGIx3Z/JJ8yT9joOeOseGWh+Jf1QeKviTXlJulmMZnd+3k60P9GLBzOaYekiWiazvQ0l1ubyVcY3ueJ6F6ZRCLsExwqA22kT3TqEYZoo/mBL7L/Y3fyX3GQ==",
        "buyer_id" => "2088702090239125",
        "invoice_amount" => "0.01",
        "notify_id" => "e2430602b97eef0da17bcebf59218ecgxe",
        "fund_bill_list" => "[{\"amount\":\"0.01\",\"fundChannel\":\"ALIPAYACCOUNT\"}]",
        "notify_type" => "trade_status_sync",
        "trade_status" => "TRADE_SUCCESS",
        "receipt_amount" => "0.01",
        "buyer_pay_amount" => "0.01",
        "app_id" => "2018020902168779",
        "sign_type" => "RSA2",
        "seller_id" => "2088001698092438",
        "gmt_payment" => "2018-02-22 13:04:57",
        "notify_time" => "2018-02-22 13:04:58",
        "version" => "1.0",
        "out_trade_no" => "2018022213034064857923",
        "total_amount" => "0.01",
        "trade_no" => "2018022221001004120284912760",
        "auth_app_id" => "2016070101572258",
        "buyer_logon_id" => "sky***@gmail.com",
        "point_amount" => "0.00"
    }
    return render status: 401 unless Pay.verify_params?(params)
    Pay.hand_alipay_payment_notification(params)

  end

  #微信扫码支付结果异步通知
  #post /v1/wechat_payment/notification
  def wechat_payment_notification
    #先把微信发来的xml数据格式转成hash
    # json = Hash.from_xml(request.body.read)["xml"]
    json = {
        "appid" => "wxc2cdfa5d6fb7caa9",
        "bank_type" => "CFT",
        "cash_fee" => "100",
        "fee_type" => "CNY",
        "is_subscribe" => "Y",
        "mch_id" => "1281019601",
        "nonce_str" => "3309c8bc767e4977845084e5c8e2e7ac",
        "openid" => "od-YYv98kR6dxIW7DsqORD1IAJik",
        "out_trade_no" => "2018020915282761745289",
        "result_code" => "SUCCESS",
        "return_code" => "SUCCESS",
        "sign" => "032A1180F6C9A62293911CFEF35F6116",
        "sub_mch_id" => "1423110002",
        "time_end" => "20180209152920",
        "total_fee" => "100",
        "trade_type" => "NATIVE",
        "transaction_id" => "4200000057201802099966659509"
    }

    #验签，确定请求来源是微信
    ##先把请求中的sign值取出来
    req_sign = json["sign"]
    ##组合待签名字符串
    str = json.except("sign").to_query + "&key=" + WxPay.key
    sign = Digest::MD5.hexdigest(str).upcase
    #如果签名不一致，说明该请求不是来自微信，直接返回401
    if req_sign != sign
      return render status: 401
    end

    #根据支付结果处理订单和流水
    Pay.hand_wechat_payment_notification(json)

    #先定义要返回的数据
    data = '<xml>
              <return_code><![CDATA[SUCCESS]]></return_code>
              <return_msg><![CDATA[OK]]></return_msg>
            </xml>'
    render status: 200, xml: data
  end

  #微信官方申请退款异步通知
  #post /v1/wechat_refund/notification
  def wechat_refund_notification
    #先把微信发来的xml数据格式转成hash
    # json = Hash.from_xml(request.body.read)["xml"]
    json = {
        "return_code" => "SUCCESS",
        "appid" => "wxc2cdfa5d6fb7caa9",
        "mch_id" => "1281019601",
        "sub_mch_id" => "1423110002",
        "nonce_str" => "7f3bbd9f8f3b9c5a11e5d0d033d9aa99",
        "req_info" => "a5K+SZzD/BXm1kYqLJ4DTTLlGIIkFnDccoK+ez2RuxF4Hi4toCCLWTuPADyyp1nZC4tcWWi7lie0R5iVf8aGBKyO+m6d/u/6ACjo+WvTlKxpH7YgJHRUKCoVc8z6iy1IKhAhBql6UZIjTrEfyI7Jb6ZyhTjSC1cRRqF7UMj59HnSgLF0MVNfQTSzlA0UQCUWEGfzPAZpp2oWtaHI8g5FMZZOHu8qWqqtZx6W5im+Q+Ab0rorvAY/1R3raFd4u+iqxkUnZWUUeUzOMKihwxL5YxtharsvSBWTJ+qdC+VxzlbZ7p0LSCjWyENFr0+VfR8cUwAH1wUcVQFSSmm/728FOPKnfi2UA/nrCfEGl0cBv+qSYiRCCVn0NKv11k+tGuMII5KeWU61STzgY0sxacXL8kYDQz0r/sfzyTSHtw/zDPbf08xfp2viUmhAtClOhOWfx7llR/yuRGzyqbCsWijt9iyA6WUIymI/BhcHqs16TrJR24mDjD5C2aYCI7CLnLWhqUZhoWDd5Hg2LFHOJzldne4rZ+DwbG6OooSCicl36z3MqyLapS/gfjmPMJfI8dGbdBa1vk92npbSgPlymoOhzE9BL/UN2Lne2xZPaiLDxm5fGQNwTBM0Dc9vpoVxQ2t6VNhIKQhzzNb0sbJcAu7ANlPDIPYYGvlGoTPfMwoRqi8EJQ7EZ08xkli2ClXWF/nolVMtdvv0BaVoaM02ncT61p/fGdnZyFcSpKKV71ZVYiqPIVhUpcAdfrKQJ46oktpAMNFRNVJ8FdyC5VDv91Bu0pNaRtDJKQm/z0cnZoHFCOUY2YtHGbn9m4Fu4O3IVwsKoGZTRVAYLj54S018HJDpLRp7A4BIeTB7z8IDZzC1C+FWcQzdoTaBywe591WjUOLzUJETLuDkOuJTGNL5kT0R0wl1D3KwWhS+TWoTZGB6IdqHaqtn8xwOiX+/kanL6XqOZuXkdU86Thwy+mv4ASzz6JL2KoP/mCP+CL0jv+gcMWDX37enGvPLmJRtsf35B8K3PW7kd/Gs8jG4hbBl5IpnexndhX8r3cxHlgRGMoTYShsEqN3U3oSEUbpA/LJr5m72"
    }
    #获取加密信息
    req_info = json["req_info"]
    #获取解密数据：返回的数据是xml格式
    data = Hash.from_xml(decryption(WxPay.key, req_info))["root"]
    #处理退款
    Pay.handle_wechat_refund(data) if data
    #定义要返回的数据
    response = '<xml>
              <return_code><![CDATA[SUCCESS]]></return_code>
              <return_msg><![CDATA[OK]]></return_msg>
            </xml>'

    render status: 200, xml: response
  end

  #使用app_auth_code换取ali_auth_token
  #get /v1/ali_auth_token?app_auth_code=xxxx
  def get_ali_auth_token
    json = Pay.get_ali_auth_token(params["app_auth_code"])
    uid = json["user_id"]
    if uid
      application = PaymentAlipayAccountApplication.find_by(pid: uid)
      payment_account = PaymentAccount.new(merchant_id: application.merchant_id,
                                           account: uid,
                                           rate: 0.006,
                                           ali_auth_token: json["app_auth_token"],
                                           ali_refresh_token: json["app_refresh_token"])
      payment_account.save
      application.payment_account = payment_account
      render status: 200
    else
      result = {
          result: "FAIL",
          err_message: json["sub_msg"]
      }
      render json: result
    end

  end


  private

  def make_collections_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:sid, :auth_code, :total_amount])
  end

  def refund_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:merchant_trade_no])
  end

  def payment_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:sid, :total_amount])
  end
end
