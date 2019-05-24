### 添加支付方式

    登录 + , 权限 +
    method: post
    uri: /v1/payment_method_channels
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "payment_accounts",
             "attributes": {
                "payment_method_id": "2",
                "payment_channel_id": "7"
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 返回所有支付方式

    登录 + , 权限 +
    method: get
    uri: /v1/payment_method_channels
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    response: 200 创建成功, 401 token问题， 403 权限问题
    
    {
        "data": [
            {
                "id": "fbd66839-68ab-4275-9912-cb9554a64aa5",
                "type": "payment-method-channels",
                "attributes": {
                    "payment-method-name": "微信支付",
                    "payment-channel-name": "第三方支付通道",
                    "enabled": true
                }
            },
            {
                "id": "f4e6ab72-e3ed-4a86-8e85-d820f3f05f2b",
                "type": "payment-method-channels",
                "attributes": {
                    "payment-method-name": "支付宝支付",
                    "payment-channel-name": "第三方支付通道",
                    "enabled": true
                }
            }
        ]
    }