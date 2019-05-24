class V1::WechatPayController < ApplicationController
  #该控制器为侧使用

  #刷卡支付，商户主扫
  #post /v1/wechat_micropay
  # body: sid=xxxxxx&auth_code=xxxxxx#total_fee=xxx
  def invoke_micropay
    #1、先使用门店id查询该门店是否开通微信支付，以及微信支付所使用的通道
    #2、再查询该门店的状态是否营业
    #3、再查询该门店所属商户的一些状态
    # binding.pry
    #查出该商户的商户号
    # merchant_id = "1423110002"
    parameters = micropay_params
    out_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(6).join
    params = {
        sub_mch_id: "1423110002",
        body: "商户名+店名",
        out_trade_no: out_trade_no,
        total_fee: parameters[:total_fee].to_i,
        spbill_create_ip: "127.0.0.1",
        auth_code: parameters[:auth_code]
    }

    #TODO 这里需要创建订单信息

    response = WxPay::Service.invoke_micropay(params).except(:raw)

    #如果支付成功且返回没有异常
    if response.success?
      #TODO 这里需要创建交易流水信息
      return render status: 200, json: response
    end

    parameters = {
        out_trade_no: out_trade_no,
        sub_mch_id: "1423110002"
    }

    #支付失败原因提示
    response = {err_message: ""}
    case response["err_code"]
      when 'ORDERPAID'
        response[:err_message] = "订单号重复, 请重新支付"
      when 'AUTHCODEEXPIRE'
        response[:err_message] = "用户的条码已经过期"


    end
    #当返回系统错误、银行系统异常或用户支付中，需要查询订单的状态，根据查询结果做对应的处理
    if response["err_code"] == 'SYSTEMERROR' || response["err_code"] == 'BANKERROR' || response["err_code"] == 'USERPAYING'
      sleep(5) #休眠5秒
      timeout = 0
      while timeout <= 25
        response = WxPay::Service.order_query(parameters).except(:raw)
        if response.success? && response["trade_state"] == 'SUCCESS' #订单支付成功
          #TODO 这里需要创建交易流水信息
          return render status: 200, json: response
        else
          sleep 5
          timeout += 5
        end
      end

      #如果超过30秒后，订单状态仍然不是支付成功，则撤销订单, 如果支付成功，款项则会原路返回
      count = 0
      while count < 10
        response = WxPay::Service.invoke_reverse(parameters).except(:raw)
        if response.success? #订单撤销成功
          return render status: 200, json: response
        end
        count += 1
      end
    end
    render json: response
  end

  #微信支付订单查询
  #get /v1/orders/order_query?out_trade_no=xxxx
  def query_order
    parameters = {
        out_trade_no: params[:out_trade_no],
        sub_mch_id: "1423110002"
    }
    response = WxPay::Service.order_query(parameters).except(:raw)
    render json: response
  end

  #撤销订单
  #get /v1/orders/reverse?out_trade_no=xxxx
  def reverse_order
    parameters = {
        out_trade_no: params[:out_trade_no],
        sub_mch_id: "1423110002"
    }
    response = WxPay::Service.invoke_reverse(parameters).except(:raw)
    render json: response
  end

  #测试支付宝扫码支付
  #get /alipay
  def alipay
    # 创建支付订单并取得订单信息
    # binding.pry

    response = $alipay_client.execute(
        method: 'alipay.trade.precreate',
        notify_url: 'https://mystore.com/orders/20160401000000/notify',
        biz_content: {
            out_trade_no: '20160401000000',
            total_amount: '50.00',
            subject: 'QR Code Test'
        }.to_json
    )
    render json: response
  end

  private
    def micropay_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:sid, :auth_code, :total_fee])
    end
end
