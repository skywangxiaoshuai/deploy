### 返回设备列表(商户管理员、店长、店员权限)
    
    登录 + , 权限 +
    method: get
    uri: /v1/stores/:store_id/store_devices
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": [
              {
                  "id": "1a6d3655-dc5c-44ef-ae8e-1f955d1f5179",
                  "type": "department-devices",
                  "attributes": {
                      "device-id": "A0101179001HJXU7"
                  }
              }
          ]
      }
      
### 绑定设备（商户管理员、店长、店员权限）
    
    登录 + , 权限 +
    method: post
    uri: /v1/stores/:store_id/store_devices
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      Content-Type: application/json
      
    request:
      {
        "data": {
          "type": "department_devices",
             "attributes": {
               "device_id": "A0101179001HJXU7",
                "acknowledgment": "123456a"
          }
        }
      }

    response: 201 成功, 401 token问题， 403 权限问题, 422参数问题

### 解绑设备（商户管理员、店长、店员权限）
    
    登录 + , 权限 +
    method: delete
    uri: /v1/store_devices/:store_device_id
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....
      
    response: 204 成功, 401 token问题， 403 权限问题