### 添加商户

    登录 + , 权限 +
    method: post
    uri: /v1/merchants
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "merchants",
             "attributes": {
                "name": "上海维浦信息技术有限公司1",
                "short_name": "维浦1",
                "brand_name": "品牌名称",
                "brand_logo": "品牌logo",
                "users_attributes": [
                	{
                	    "login_name": "witspool1",
              		    "password": "123456a"
                	}
                	
                ]
               
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 根据名字筛选商户

    登录 + , 权限 +
    method: get
    uri: /v1/merchants/search_by_name?q=123 #q不存在时返回所有商户
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
     
    response: 200 成功, 401 token问题， 403 权限问题 
    {
        "data": [
            {
                "id": "17990c3e-49f3-42c8-b5d3-668051f5cb20",
                "type": "merchants",
                "attributes": {
                    "name": "上海维浦信息技术有限公司"
                }
            },
            {
                "id": "132c189e-90b9-4cae-b08f-ed1d3a3230ee",
                "type": "merchants",
                "attributes": {
                    "name": "上海维浦信息技术有限公司1"
                }
            }
        ]
    }