### 扫码收款
   
    登录 + 
    method: post
    uri: /v1/gathering
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "pays",
             "attributes": {
                "sid": "97f076e5-e7d3-4d88-8571-277c87434ccc", #门店id
                "auth_code": "134637290126095871", #授权码
                "total_amount": 100 #总金额
          }
        }
      }

    response: 200 创建成功, 401 token问题
    支付成功：
        {
            "result_code": "SUCCESS",
            "total_amount": "1",
            "channel_transaction_id": "4200000057201802089265546655", #渠道方交易流水号
            "merchant_trade_no": "2018020816260992378541" #商户订单号
        }
        
    需要查询订单再才能做后续处理的情况
        
        #如果查询成功，则返回订单的状态，例：
        
        {
            "result": "FAIL",
            "err_message": "订单未支付"
        }
    
        #如果查询失败并超时，则撤销订单。如果撤销成功：
        {
            "result": "FAIL",
            "err_message": "该订单已撤销"
        }
        #如果撤销失败
        {
            "result": "FAIL",
            "err_message": "收款失败，请重新收款"
        }
    
    
        其他错误
        {
            "result": "FAIL",
            "err_message": "每个二维码仅限使用一次，请刷新再试"
        }
    
        {
            "result": "FAIL",
            "err_message": "付款码无效，请重新扫码"
        }
        
        
### 退款
   
    登录 + ， 权限 +
   
    method: post
    uri: /v1/gathering
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
        {
          "data": {
            "type": "pays",
               "attributes": {
                  "merchant_trade_no": "2018020915282761745289" #商户订单号
            }
          }
        }
     
     response: 200, 401, 403
        {
            "result": "SUCCESS",
            "message": "退款申请成功"
        }
        
        {
              result: "FAIL",
              err_message: "订单已全额退款" 
          }
          
### 微信扫码付款
    method: post
        uri: /v1/gathering
        header: 
          Content-Type: application/json
          Authorization: Bearer eyJ0eXAiOiJKV1Qi....
    
    request:
        {
          "data": {
            "type": "pays",
               "attributes": {
                  "sid": "97f076e5-e7d3-4d88-8571-277c87434ccc", #门店id
                  "total_amount": 100  #总金额
            }
          }
        }
        
    response: 200
        {
            "result": "SUCCESS",
            "code_url": "weixin://wxpay/bizpayurl?pr=WYYbGqi"
        }
        
        {
            "result": "FAIL",
            "err_message": "受理机构必须传入sub_mch_id"
        }