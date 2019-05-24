### 添加商户账户

    登录 + , 权限 +
    method: post
    uri: /v1/payment_accounts
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "payment_accounts",
             "attributes": {
                "name": "上海维浦信息技术有限公司",
                "merchant_id": "17990c3e-49f3-42c8-b5d3-668051f5cb20",
                "channel_id":7,
                "account": "31415926",
                "rate": 0.001
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 返回商户账户列表

    登录 + , 权限 +
    method: get
    uri: /v1/payment_accounts?page=1&size=1
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    response: 200 创建成功, 401 token问题， 403 权限问题
    
    {
        "data": [
            {
                "id": "6f662794-f7b3-43e9-b12d-e4878768edae",
                "type": "payment-accounts",
                "attributes": {
                    "account": "31415926",
                    "enabled": true,
                    "channel": "第三方支付通道",
                    "name": "上海维浦信息技术有限公司"
                }
            },
            {
                "id": "d6105a9b-67d2-4189-a3ac-381244f011a9",
                "type": "payment-accounts",
                "attributes": {
                    "account": "2088001698092438",
                    "enabled": true,
                    "channel": null,
                    "name": null
                }
            },
            {
                "id": "2ea6581b-1d79-415c-8856-30f5c50580a1",
                "type": "payment-accounts",
                "attributes": {
                    "account": "1423110002",
                    "enabled": true,
                    "channel": null,
                    "name": null
                }
            }
        ],
        "links": {},
        "meta": {
            "total-count": 3
        }
    }