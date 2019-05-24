### 添加门店

    登录 + , 权限 +
    method: post
    uri: /v1/stores
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "stores",
             "attributes": {
                "name": "上海维浦金科路店",
                "description": "维浦",
                "address": "上海市浦东新区郭守敬路498号1号楼330",
                "contact_phone": "075211800900",
                "materials_attributes": [
                {
                  "name": "门头照", #照片资料名称
                  "picture": "data:image/png;base64,iVBORw0KG...." #照片base64
                },
                {
                  "name": "店内照1",
                  "picture": "data:image/png;base64,iVBORw0KG...."
                }
                ]
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
  
### 修改门店(商户管理员权限)

    登录 + , 权限 +
    method: put
    uri: /v1/stores/:id
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    #即使参数没有更改也要全部发送到服务器
    request:
      {
        "data": {
          "type": "stores",
             "attributes": {
                "name": "上海维浦金科路店",
                "description": "维浦",
                "address": "上海市浦东新区郭守敬路498号1号楼330",
                "contact_phone": "075211800900",
                "materials_attributes": [
                    {
                      "name": "门头照", #照片资料名称
                      "picture": "data:image/png;base64,iVBORw0KG...." #照片base64
                    },
                    {
                      "name": "店内照1",
                      "picture": "data:image/png;base64,iVBORw0KG...."
                    }
                ]
          }
        }
      }

    response: 200 更新成功, 401 token问题， 403 权限问题， 422 参数验证问题

    
### 返回门店列表(商户管理员权限)
    登录 + , 权限 +
    method: get
    uri: /v1/stores
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    {
        "data": [
            {
                "id": "6b125ecf-e1b4-4882-9ca3-1d0f8519d381",
                "type": "departments",
                "attributes": {
                    "name": "上海维浦金科路店",
                    "enabled": true,
                    "qrcode-url": "https://www.yapos.cn/example?sid=6b125ecf-e1b4-4882-9ca3-1d0f8519d381" #门店二维码链接
                }
            },
            {
                "id": "16b5de9e-0d66-407f-8139-7196e2c76150",
                "type": "departments",
                "attributes": {
                    "name": "上海维浦川沙店",
                    "enabled": true,
                    "qrcode-url": "https://www.yapos.cn/example?sid=16b5de9e-0d66-407f-8139-7196e2c76150"
                }
            },
            {
                "id": "102a44e2-9551-4cbc-9f5e-a15ec6bd1bc5",
                "type": "departments",
                "attributes": {
                    "name": "上海维浦浦东店",
                    "enabled": true,
                    "qrcode-url": "https://www.yapos.cn/example?sid=102a44e2-9551-4cbc-9f5e-a15ec6bd1bc5"
                }
            }
        ]
    }
    
### 查看门店信息(商户管理员、店长、店员权限)
    登录 + , 权限 +
    method: get
    uri: /v1/stores/:id
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    {
        "data": {
            "id": "16b5de9e-0d66-407f-8139-7196e2c76150",
            "type": "departments",
            "attributes": {
                "name": "上海维浦川沙店",
                "enabled": true,
                "qrcode-url": "https://www.yapos.cn/example?sid=16b5de9e-0d66-407f-8139-7196e2c76150",
                 "materials": [
                    {
                        "name": "门头照",
                        "picture": "/system/materials/f7522f93-1f20-462c-9d07-a96e98d8476c/pictures/large.png?1519883804"
                    },
                    {
                        "name": "店内照1",
                        "picture": "/system/materials/03e6685b-8370-4b64-b9d8-58280c5f2f1a/pictures/large.png?1519883804"
                    }
                ]
            }
        }
    }
    
    
### 为某个门店添加店员(商户管理员权限)

    登录 + , 权限 +
    method: post
    uri: /v1/stores/:id/users
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "stores",
             "attributes": {
               "name": "张三",
                "password": "123456a",
                "login_name": "zhangsan4", #ID
                "contact_phone": "17521180090",
                "role_ids": ["a0c5dd82-e370-41d2-8826-2a94bcedf158"]
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 修改店员信息(商户管理员权限)

    登录 + , 权限 +
    method: put
    uri: /v1/store_users/:id
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "stores",
             "attributes": {
               "store_id": "16b5de9e-0d66-407f-8139-7196e2c76150",  #所属门店如果没有变化，传null值
               "role_ids": ["a0c5dd82-e370-41d2-8826-2a94bcedf158"] #角色如果没有改变， 传null值
          }
        }
      }

    response: 200 更新成功, 401 token问题， 403 权限问题， 422 参数验证问题
    
### 返回商户的店员列表（商户管理员权限）

    登录 + , 权限 +
    method: get
    uri: /v1/store_users
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
      {
          "data": [
              {
                  "id": "80228643-b55f-4c94-9ca4-0acbfd508304",
                  "type": "users",
                  "attributes": {
                      "login-name": "zhangsan4",
                      "name": "张三",
                      "contact-phone": "17521180090",
                      "role": [
                          "店长"
                      ],
                      "store": "上海维浦金科路店"
                  }
              },
              {
                  "id": "2b7c03dd-fd42-419a-ac0f-0685ac6914f3",
                  "type": "users",
                  "attributes": {
                      "login-name": "zhangsan5",
                      "name": "张三",
                      "contact-phone": "17521180090",
                      "role": [
                          "店长"
                      ],
                      "store": "上海维浦川沙店"
                  }
              }
          ]
      }
      
### 查看门店店员信息（商户管理员权限）

    登录 + , 权限 +
    method: get
    uri: /v1/store_users
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题
      {
          "data": {
              "id": "80228643-b55f-4c94-9ca4-0acbfd508304",
              "type": "users",
              "attributes": {
                  "login-name": "zhangsan4",
                  "name": "张三",
                  "contact-phone": "17521180090",
                  "role": [
                      "店长"
                  ],
                  "store": "上海维浦金科路店"
              }
          }
      }