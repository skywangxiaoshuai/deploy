### 添加支付通道

    登录 + , 权限 +
    method: post
    uri: /v1/payment_methods
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "payment_methods",
             "attributes": {
                "name": "第三方支付通道",
                "description": "第三方支付通道",
                "rate": "0.38%--0.60%",
                "application_material": "需要营业执照照片，对公银行账户等"
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 返回所有支付通道

    登录 + , 权限 +
    method: get
    uri: /v1/payment_channels
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    response: 200 创建成功, 401 token问题， 403 权限问题
    
    {
        "data": [
            {
                "id": "1",
                "type": "payment-channels",
                "attributes": {
                    "name": "微信官方",
                    "rate": null,
                    "enabled": null,
                    "description": null
                }
            },
            {
                "id": "5",
                "type": "payment-channels",
                "attributes": {
                    "name": "第三方支付通道",
                    "rate": "0.38%--0.60%",
                    "enabled": true,
                    "description": "第三方支付通道"
                }
            }
        ]
    }
    
### 配置支付通道所支持的支付方式

    登录 + , 权限 +
    method: post
    uri: /v1/payment_channel/7/payment_methods
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "payment_methods",
             "attributes": {
                "payment_methods": [1, 2] #数组元素为支付方式的id
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题