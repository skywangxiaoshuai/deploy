### 添加支付方式

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
                "name": "百度钱包",
                "description": "百度钱包描述"
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 返回所有支付方式

    登录 + , 权限 +
    method: get
    uri: /v1/payment_methods
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    response: 200 创建成功, 401 token问题， 403 权限问题
    
    {
        "data": [
            {
                "id": "1",
                "type": "payment-methods",
                "attributes": {
                    "name": "微信支付"
                }
            },
            {
                "id": "2",
                "type": "payment-methods",
                "attributes": {
                    "name": "支付宝支付"
                }
            },
            {
                "id": "3",
                "type": "payment-methods",
                "attributes": {
                    "name": "百度钱包"
                }
            }
        ]
    }