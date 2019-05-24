class Pay < ApplicationRecord
  class << self
    WECHAT_FORMAT = /\A1[0|1|2|3|4|5][0-9]\d{15}\z/ #18位纯数字，以10、11、12、13、14、15开头
    ALIPAY_FORMAT = /\A(25|26|27|28|29|30)[0-9]\d{13,21}\z/ #支付授权码，25~30开头的长度为16~24位的数字
    PRIVATE_KEY = "MIIEowIBAAKCAQEAs8dqG61EcWxzOSnANpagSFv7zXqpfyd8A6/7CdNjS8PW25dFxRVfVmCbaTcwxX2uBnSXc8rT0oyaSMZhV+Vsqd9+6szAft6xcBdo4EOA1fjMj9vxNX/LFWfMEr/6CbTYSAK1nOeWFXGsYlwjcLtsWB7nSsqDORpdCh4iyOqorqCt1lxdl9eoqQf+O8/KGrSEOALfug0FZbbNAX7s1Zxlcw0Ei2MuJ3BGEX3cjsFrklH0b6RtbUw32NbniN4t1CMOJ+k0BzDuCbggeRx5/ORORyaBVoKr6DXyVHF57L36hsN8AspZ73FqJhxYjeDYKWA2jl1hpUKee3XXiDAyN/ubGwIDAQABAoIBAFUX0lV/UaIOHwuzg1NTQFJ/l1PO92NEISLtrPkdoSY/b/dIRrHeR93upCDNCryvnCtaDEW2f0RtYKmJnJGp+iD9tGkWuRZT+dCAhBeCW/zrYofFJwqXjlx3YNSPIZ5uhuCux5+YziUgROPZkLzPOZ0MI5X2/N2OaPNdCEHpMCZXBAv24mz+B1zdhYPkCYNOf0PAu21/YxHb7fsi9OMracJhJO9HhSntmgFalS9Pi1wuOa83IZdM4HcTAKPNHa7Ha7eYmTw3hWGCe8QY3wRfvI1J7IOi6SyIlyJppg06Fi75Dq/JmCvx2xnJlgPQu4UQdNNckPRBu5ZTjFtd1XpC8EECgYEA4rD9mx3I1S8meYiksyqMz6HtNRFupLXSWrMxymYOQEV6NpVSZiRQVKt3PhlrOHhr6AVQ+WDFFRI6FVE1/8tbxd/BnaiSX+mLFxL/sbzce4/g0RjaFcQKrHybx2pdDa3llt8CVf1ciuiI9UY1wtjHKqVpzBDVDJo5ZCzBeOC5bFkCgYEAywW4sd+QGBT9/LdQnInz/TEaqHYnmX0YxSvMD7voOXcIKgZ33vFgBI2zPs9aAcCGXgogFOQrCYXZdvO0tjSTK6Luovkauq6WGZ509jlfZL94tWCwGzaKpOxDF3/FBO+3dOVBmFmnN64J1TBwXLxYhwrXnxSFeJfLO9/roWg5BJMCgYEArVmzVZ8dKQj5Xw7DA8+SBmVJQ7+k4Ie56GoHtUL9uuBmaL8fV8SFOXo1oWNGvtQ3kCIgndMGYuqhSBPmO0mDUHmfUbTK2lV5a5e3uG84G7UWsk9S1jon/2b6qTAJIKDOZOT8oE0zK3ZO5WFfUzT6eP4tPUPR5+U35gbjnFAc+2ECgYAuKfDjUUh8kVlne29zCNNYATBkmelLN2zIeLr/4ORfHLfYhnv/T7dbkbTuVUvMFjD3dSnyVieLFMpsB+JRhAbq5zOID0iKpmQvEx7ZVhZg3EDgTUn+BhrkgWyIDV+JTdDTXcXalJg3SvWlakxCaflfS5HX9FydHTbzOGll3EMKzQKBgBu8DjUEjEA7C21auATnH+ZP69xRL+ZoTdfjORK26hFPd/L4AqYUJWa1kdhk5Okp7WOq1oiHel4UY81nvtPoQzaLRJGfTOLdJRM05mw47Rx8v3mYI66UXuhq6CJN2/hVC/glsEZBcOfZREahQu280mXQJg93EpUkx5U3xL/mYjtm"
    ALIPAY_PUBLIC_KEY="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqBaK1pV/jEtuzU3MfaB5EqmjZrK4NZWHyEegGSFLAjhGPzvVdC9K7NkDMskbmLBH2f7yoxODIb7uMyweTfzqWfb7LVdm9F6zFBPjO2gcrOWmVziV4WpFyDf+q2sOkuUtMw2yGh2WGPmkwxdKvIRb0kZlX+5gFs25PpsqNBE18j4jA0vELIZP33Xz05xxDQODZh7bWM8HDT9EqSd5PJmu7QbCC46juVGO1JaDtRaG5cBw3fbVxN8LL5eLcBYcl4rHIvglvn819jnHNd5u5Tb4ouFY6/7oZLAwohReM83gNJEmH/cq3ZGYmU/hwHzW9kehPvFdJpJ1BiSlD3cWqXd8aQIDAQAB"
    APPID = "2018020902168779"
    CHARSET = "utf-8"
    SIGN_TYPE = "RSA2"
    VERSION = "1.0"

    #判断是微信条码还是支付宝条码
    def judge_payment_method(auth_code)
      method = ""
      if auth_code.match(WECHAT_FORMAT).present?
        method = "wechat"
      elsif auth_code.match(ALIPAY_FORMAT).present?
        method = "alipay"
      end
      return method
    end

    #调用微信官方的刷卡支付
    def invoke_wechat_micropay(order, store, auth_code)
      params = {
          sub_mch_id: order.merchant_no,
          body: store.name,
          out_trade_no: order.merchant_trade_no,
          total_fee: order.total_amount,
          spbill_create_ip: "127.0.0.1",
          auth_code: auth_code
      }
      response = WxPay::Service.invoke_micropay(params).except(:raw)
      # response[:action] = "trade" #用于标记该返回值是收款接口返回
      #如果支付成功且返回没有异常
      if response.success?
        Pay.handle_wechat_order(order, store, response)
        result = {
            result: "SUCCESS",
            total_amount: response["total_fee"],
            channel_transaction_id: response["transaction_id"],
            merchant_trade_no: response["out_trade_no"]
        }
        return result
      end

      parameters = {
          out_trade_no: order.merchant_trade_no,
          sub_mch_id: order.merchant_no
      }

      #当返回系统错误、银行系统异常或用户支付中，需要查询订单的状态，根据查询结果做对应的处理
      err_code = response["err_code"]
      if err_code == 'SYSTEMERROR' || err_code == 'BANKERROR' || err_code == 'USERPAYING'
        sleep(5) #休眠5秒
        timeout = 0
        while timeout <= 25
          response = WxPay::Service.order_query(parameters).except(:raw)
          if response.success? && response["trade_state"] == 'SUCCESS' #订单支付成功
            Pay.handle_wechat_order(order, store, response)
            result = {
                result_code: "SUCCESS",
                total_amount: response["total_fee"],
                channel_transaction_id: response["transaction_id"],
                merchant_trade_no: response["out_trade_no"]
            }
            return result
          end

          if response.success? && response["trade_state"] != 'USERPAYING'
            case response["trade_state"]
              when 'NOTPAY'
                order.update(status: 3) #订单未支付
              when 'CLOSED'
                order.update(status: 4) #订单已关闭
              else
                order.update(status: 2) #支付失败
            end
            result = {
                result: "FAIL",
                err_message: response["trade_state_desc"].gsub(/[0-9]/, '')
            }
            return result
          end

          if response.success? && response["strade_state"] == 'USERPAYING'
            order.update(status: 9) #用户支付中
          end
          sleep 5
          timeout += 5
        end

        order.update(status: 7) #订单状态未知
        #如果超过30秒后，订单状态仍然未知，则撤销订单, 如果支付成功，款项则会原路返回
        count = 0
        while count < 10
          response = WxPay::Service.invoke_reverse(parameters).except(:raw)
          # response[:action] = "revoke" #用于标记该返回值是撤销订单的返回数据
          if response.success? #订单撤销成功
            order.update(status: 5) #更新订单状态为已撤销
            result = {
                result: "FAIL",
                err_message: "该订单已撤销"
            }
            return result
          end
          count += 1
        end
        #如果撤销订单失败
        result = {
            result: "FAIL",
            err_message: "收款失败，请重新收款"
        }
        return result
      end
      if response["return_code"] == "FAIL"
        result = {
            result: "FAIL",
            err_message: response["return_msg"].gsub(/[0-9]/, '')
        }
        return result
      else
        result = {
            result: "FAIL",
            err_message: response["err_code_des"].gsub(/[0-9]/, '')
        }
        return result
      end
    end

    #调用微信官方的扫码支付, 若是成功，则返回二维码链接，若是失败，则返回失败原因
    def invoke_wechat_native_pay(order, store)
      params = {
          body: store.name,
          sub_mch_id: order.merchant_no,
          out_trade_no: order.merchant_trade_no,
          total_fee: order.total_amount,
          spbill_create_ip: '127.0.0.1',
          notify_url: 'https://api.witspool.com/standard/v1/wxpay_notification',
          trade_type: 'NATIVE'
      }
      response = WxPay::Service.invoke_unifiedorder(params).except(:raw)
      if response.success?
        result = {
            result: 'SUCCESS',
            code_url: response["code_url"]
        }
        return result
      elsif response["return_code"] == 'FAIL'
        result = {
            result: "FAIL",
            err_message: response["return_msg"]
        }
        return result
      else
        result = {
            result: "FAIL",
            err_message: response["err_code_des"]
        }
        return result
      end
    end

    #处理微信异步通知返回的扫码支付结果
    def hand_wechat_payment_notification(data)
      order = PaymentOrder.find_by(merchant_trade_no: data["out_trade_no"])
      store = order.store
      return if order.status != 'NOTPAY' #如果订单的状态不是未支付，则表明该订单已经处理过
      if data["return_code"] == 'SUCCESS' && data["result_code"] == 'SUCCESS' #支付成功
        #更新订单
        order.channel_transaction_id = data["transaction_id"]
        order.consumer_id = data["openid"]
        order.trade_type = data["trade_type"]
        order.receipt_amount = data["cash_fee"]
        order.status = 'SUCCESS'
        order.save
        #创建交易流水
        params = {
            channel_transaction_id: order.channel_transaction_id,
            merchant_trade_no: order.merchant_trade_no,
            merchant_id: order.merchant_id,
            business_type: 1,
            income_expenses_type: 1,
            payment_channel_id: order.payment_channel_id,
            payment_method_id: order.payment_method_id,
            amount: order.total_amount
        }
        #创建收入流水
        params[:business_type] = 1
        params[:income_expenses_type] = 1
        payment_transaction = store.payment_transactions.new(params)
        payment_transaction.save
        #如果此次交易手续费存在，创建扣除手续费流水
        amount = (payment_transaction.amount * order.rate).round
        if amount != 0
          params[:business_type] = 3
          params[:income_expenses_type] = 2
          params[:amount] = amount
          params[:merchant_trade_no] = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
          payment_transaction1 = store.payment_transactions.new(params)
          payment_transaction1.save
        end
      else
        order.update(status: 'FAIL')
      end
    end

    #调用微信官方申请退款接口
    def invoke_wechat_rerund(order)
      merchant_refund_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
      params = {
          sub_mch_id: order.merchant_no,
          out_trade_no: order.merchant_trade_no,
          out_refund_no: merchant_refund_no,
          total_fee: order.total_amount,
          refund_fee: order.total_amount
      }

      response = WxPay::Service.invoke_refund(params).except(:raw) #申请退款接口，申请后要查询退款状态确认退款是否成功
      if response.success?
        order.update(status: 'REFUNDING') #更新订单状态为退款中
        result = {
            result: "SUCCESS",
            message: "退款申请成功"
        }
        return result
      end
      if response["err_code"] == "SYSTEMERROR" || response["err_code"] == "BIZERR_NEED_RETRY"
        count = 0
        while count < 5
          response = WxPay::Service.invoke_refund(params).except(:raw)
          if response.success?
            order.update(status: 'REFUNDING') #更新订单状态为退款中
            result = {
                result: "SUCCESS",
                message: "退款申请成功"
            }
            return result
          end
        end
        result = {
            result: "FAIL",
            err_message: response["err_code_des"]
        }
        return result
      end
      if response["return_code"] == "FAIL"
        result = {
            result: "FAIL",
            err_message: response["return_msg"]
        }
        return result
      else
        result = {
            result: "FAIL",
            err_message: response["err_code_des"]
        }
        return result
      end
    end

    #处理微信异步返回的退款结果
    def handle_wechat_refund(data)
      # binding.pry
      order = PaymentOrder.find_by(merchant_trade_no: data["out_trade_no"])
      #如果该退款已经处理过，跳出方法
      if order.refund_status
        return
      end
      if data["refund_status"] == 'SUCCESS'
        #更新订单状态，status 6表示该订单已退款
        order.update(status: 'REFUNDED',
                     merchant_refund_no: data["out_refund_no"],
                     refund_amount: data["settlement_refund_fee"],
                     refund_status: 'REFUND_SUCCESS')
        #添加退款流水单
        payment_transaction = PaymentTransaction.find_by(merchant_trade_no: order.merchant_trade_no)
        #把payment_transaction记录复制一份赋值给p
        p = payment_transaction.dup
        p.channel_transaction_id = data["transaction_id"]
        p.business_type = 2 #业务类型：退款
        p.income_expenses_type = 2
        p.merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        p.save
        #如果要退回的手续费存在，添加退回手续费流水单
        amount = (p.amount * order.rate).round #amount单位是分，所以手续费四舍五入保留整数
        if amount >=1
          p1 = p.dup
          p1.business_type = 4 #业务类型：退回交易手续费
          p1.income_expenses_type = 1
          p1.merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
          p1.amount = amount
          p1.save
        end
      else
        order.update(status: 'SUCCESS', refund_status: 'REFUND_FAIL')
      end
    end

    #使用支付宝的app_auth_code换取支付宝商户授权令牌
    def get_ali_auth_token(code)
      grant_type = "authorization_code"
      parameters = {
          method: "alipay.open.auth.token.app",
          biz_content: "{\"grant_type\":\"#{grant_type}\",\"code\":\"#{code}\"}",
      }

      Pay.invoke_alipay_api(parameters)["alipay_open_auth_token_app_response"]
    end

    #更新支付宝商户授权令牌
    def refresh_ali_auth_token(ali_refresh_token)

    end

    #调用支付宝官方的条码支付
    def invoke_alipay_trade_pay(order, store, auth_code, app_auth_token)
      #向支付宝发起支付请求的基本参数
      parameters = {
          biz_content: "{\"out_trade_no\": \"#{order.merchant_trade_no}\",\"total_amount\": \"#{(order.total_amount / 100.0).round(2).to_s}\", \"subject\": \"#{store.name}\", \"scene\": \"bar_code\", \"auth_code\": \"#{auth_code}\"}",
          method: 'alipay.trade.pay',
          app_auth_token: app_auth_token,
      }
      response = Pay.invoke_alipay_api(parameters)['alipay_trade_pay_response']
      # Pay.send_message("123", "success")
      if response["code"] == "10000" #收款成功
        Pay.handle_alipay_order(order, store, response)
        result = {
            result: "SUCCESS",
            total_amount: response["total_amount"],
            channel_transaction_id: response["trade_no"],
            merchant_trade_no: response["out_trade_no"]
        }
        return result
      end
      #如果接口返回错误需要立即查询订单，根据查询订单的结果进行相应处理
      if response['sub_code'] == 'ACQ.SYSTEM_ERROR'
        parameters[:method] = 'alipay.trade.query'
        parameters[:biz_content] = "{\"out_trade_no\": \"#{order.merchant_trade_no}\"}"
        parameters[:app_auth_token] = app_auth_token

        timeout = 0
        while timeout <= 25
          response = Pay.invoke_alipay_api(parameters)['alipay_trade_query_response']
          if response['code'] == '10000' && response['trade_status'] == 'TRADE_SUCCESS'  #查询到的订单已经支付成功
            Pay.handle_alipay_order(order, store, response)
            result = {
                result: "SUCCESS",
                total_amount: response["total_amount"],
                channel_transaction_id: response["trade_no"],
                merchant_trade_no: response["out_trade_no"]
            }
            return result
          end
          if response['code'] == '10000' && response['trade_status'] == 'TRADE_CLOSED'
            order.update(status: 4) #订单已关闭
            result = {
                result: "FAIL",
                err_message: '订单已关闭'
            }
            return result
          end
          order.update(status: 9) #用户支付中
          sleep 5
          timeout += 5
        end

        #如果查询订单没有得到明确的支付状态或者查询订单超时，则执行撤销订单操作
        order.update(status: 7) #订单状态未知
        parameters[:method] = 'alipay.trade.cancel'
        parameters[:biz_content] = "{\"out_trade_no\": \"#{order.merchant_trade_no}\"}"
        parameters[:app_auth_token] = app_auth_token
        count = 0
        while count < 5
          response = Pay.invoke_alipay_api(parameters)['alipay_trade_cancel_response']
          if response['code'] == '10000'
            order.update(status: 5)
            result = {
                result: "FAIL",
                err_message: "该订单已撤销"
            }
            return result
          end
          count += 1
        end
        #如果撤销订单失败
        result = {
            result: "FAIL",
            err_message: "收款失败，请重新收款"
        }
        return result
      end
      result = {
          result: "FAIL",
          err_message: response['sub_msg']
      }
      return result
    end

    #调用支付宝官方的扫码支付
    def invoke_alipay_native_pay(order, store, app_auth_token)
      parameters = {
          biz_content: "{\"out_trade_no\": \"#{order.merchant_trade_no}\", \"total_amount\": \"#{(order.total_amount / 100.0).round(2).to_s}\", \"subject\": \"#{store.name}\"}",
          method: 'alipay.trade.precreate',
          notify_url: 'https://api.witspool.com/standard/v1/wxpay_notification',
          app_auth_token: app_auth_token,
      }
      response = Pay.invoke_alipay_api(parameters)["alipay_trade_precreate_response"]
      if response['code'] == '10000'
        result = {
            result: 'SUCCESS',
            code_url: response["qr_code"]
        }
        return result
      end
    end

    #调用支付宝申请退款接口
    def invoke_alipay_refund(order, app_auth_token)
      out_request_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
      parameters = {
          biz_content: "{\"out_trade_no\": \"#{order.merchant_trade_no}\",\"refund_amount\": \"#{(order.receipt_amount / 100.0).round(2).to_s}\", \"out_request_no\": \"#{out_request_no}\"}",
          method: 'alipay.trade.refund',
          app_auth_token: app_auth_token,
      }
      response = Pay.invoke_alipay_api(parameters)['alipay_trade_refund_response']
      if response['code'] == '10000'
        #更新订单状态，status 6表示该订单已退款
        order.update(status: 'REFUNDED',
                     merchant_refund_no: out_request_no,
                     refund_amount: response['refund_fee'].to_f * 100,
                     refund_status: 'REFUND_SUCCESS')
        #添加退款流水单
        payment_transaction = PaymentTransaction.find_by(merchant_trade_no: order.merchant_trade_no)
        #把payment_transaction记录复制一份赋值给p
        p = payment_transaction.dup
        p.channel_transaction_id = response['trade_no']
        p.business_type = 2 #业务类型：退款
        p.income_expenses_type = 2
        p.merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        p.save
        #如果要退回的手续费存在，添加退回手续费流水单
        amount = (p.amount * order.rate).round #amount单位是分，所以手续费四舍五入保留整数
        if amount >=1
          p1 = p.dup
          p1.business_type = 4 #业务类型：退回交易手续费
          p1.income_expenses_type = 1
          p1.merchant_trade_no = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
          p1.amount = amount
          p1.save
        end
        result = {
            result: "SUCCESS",
            message: "退款申请成功"
        }
        return result
      end
      result = {
          result: "FAIL",
          message: response['sub_msg']
      }
      return result
    end

    #支付宝回调验签
    def verify_params?(params)
      sign = params['sign']
      data = params.except("sign", "sign_type").sort.map { |item| item.join('=') }.join('&')
      rsa_public_key = OpenSSL::PKey::RSA.new(Base64.decode64(ALIPAY_PUBLIC_KEY))
      if rsa_public_key.verify('sha256', Base64.decode64(sign), data.force_encoding("utf-8"))
        true
      else
        false
      end
    end

    #处理支付宝扫码支付支付异步通知
    def hand_alipay_payment_notification(data)
      order = PaymentOrder.find_by(merchant_trade_no: data["out_trade_no"])
      store = order.store
      return if order.status != 'NOTPAY' #如果订单的状态不是未支付，则表明该订单已经处理过
      if data["trade_status"] == "TRADE_SUCCESS"
        Pay.handle_alipay_order(order, store, data)
      else
        order.update(status: 'FAIL')
      end
    end

    def handle_wechat_order(order, store, response)
      #更新订单
      order.channel_transaction_id = response["transaction_id"]
      order.consumer_id = response["openid"]
      order.trade_type = response["trade_type"]
      order.receipt_amount = response["cash_fee"]
      order.status = 'SUCCESS'
      order.save
      #创建交易流水
      params = {
          channel_transaction_id: order.channel_transaction_id,
          merchant_trade_no: order.merchant_trade_no,
          merchant_id: order.merchant_id,
          business_type: 1,
          income_expenses_type: 1,
          payment_channel_id: order.payment_channel_id,
          payment_method_id: order.payment_method_id,
          amount: order.receipt_amount
      }
      #创建收入流水
      params[:business_type] = 1
      params[:income_expenses_type] = 1
      payment_transaction = store.payment_transactions.new(params)
      payment_transaction.save
      #如果此次交易手续费存在，创建扣除手续费流水, 与收入流水使用不同的merchant_trade_no
      amount = (payment_transaction.amount * order.rate).round
      if amount != 0
        params[:business_type] = 3
        params[:income_expenses_type] = 2
        params[:amount] = amount
        params[:merchant_trade_no] = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        payment_transaction1 = store.payment_transactions.new(params)
        payment_transaction1.save
      end
    end

    def handle_alipay_order(order, store, response)
      #更新订单
      order.channel_transaction_id = response["trade_no"]
      order.consumer_id = response["buyer_logon_id"]
      order.trade_type = 'ALIPAY_TIAOMA'
      order.receipt_amount = response["receipt_amount"].to_f * 100
      order.status = 'SUCCESS'
      order.save
      #创建交易流水
      params = {
          channel_transaction_id: order.channel_transaction_id,
          merchant_trade_no: order.merchant_trade_no,
          merchant_id: order.merchant_id,
          business_type: 1,
          income_expenses_type: 1,
          payment_channel_id: order.payment_channel_id,
          payment_method_id: order.payment_method_id,
          amount: order.receipt_amount
      }
      #创建收入流水
      params[:business_type] = 1
      params[:income_expenses_type] = 1
      payment_transaction = store.payment_transactions.new(params)
      payment_transaction.save
      #如果此次交易手续费存在，创建扣除手续费流水, 与收入流水使用不同的merchant_trade_no
      amount = (payment_transaction.amount * order.rate).round
      if amount != 0
        params[:business_type] = 3
        params[:income_expenses_type] = 2
        params[:amount] = amount
        params[:merchant_trade_no] = Time.now.strftime("%Y%m%d%H%M%S") + [*"1".."9"].sample(8).join
        payment_transaction1 = store.payment_transactions.new(params)
        payment_transaction1.save
      end
    end

    def invoke_alipay_api(parameters)
      parameters = {
          timestamp: Time.now.localtime('+08:00').strftime("%Y-%m-%d %H:%M:%S"),
          app_id: APPID,
          charset: CHARSET,
          sign_type: SIGN_TYPE,
          version: VERSION
      }.merge(parameters)
      #要签名的数据
      data = parameters.sort.map {|item| item.join('=') }.join('&')
      #转换成对应格式的秘钥
      pri = OpenSSL::PKey::RSA.new(Base64.decode64(PRIVATE_KEY))
      # 使用RSA2（sha256）签名方式进行签名，然后进行base64编码，然后去掉 某些转义字符
      sign = Base64.encode64(pri.sign('sha256', data.force_encoding("utf-8"))).delete("\n").delete("\r")
      parameters[:sign] = sign
      response = RestClient.get('https://openapi.alipay.com/gateway.do', {params: parameters})
      # 把返回的结果解析成json
      JSON.parse(response.body)
    end

    def send_message(topic, message)
      client = MQTT::Client.connect(
          # :host => 'mqtt.localdomain',
          # :port => 8883,
          # :ssl => true,
          :host => 'localhost',
          :port => 1883,
          :username => 'yapos',
          :password => 'Production2017',
          :client_id => 'yapos'

      )
      client.publish(topic, message, false, 0)
      client.disconnect()
    end


  end

end
