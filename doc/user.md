### 字段说明

    name: 名称
    login_name: 登录名
    description: 描述
    is_disabled: false为禁用，true为启用
    audit: verifing: 审核中, verified: 审核通过, reject: 审核失败，跟该用户所属的代理商或者商户的审核状态保持一致
    department: 所属部门
    department_id: 所属部门id
    roles: 该用户拥有的角色
    role_id: 角色id集合
    avatar: 头像
    password: 密码
    password_confirmation: 确认密码
    original_password: 原密码


### 添加用户

    登录 + , 权限 +
    method: post
    uri: /v1/users
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "name": "张三",
                "password": "12345678",
                "login_name": "zhangsan4",
                "description": "这是一个普通员工",
                "department_id": "dbbbd12c-8629-4ff2-9b3e-711b3652884e",
                "role_id": ["7bb30c91-8894-4f18-bc39-5674635396c3"]
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 查看用户列表

    登录 + , 权限 +
    method: get 
    uri: /v1/users?page=1&size=2
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": [
              {
                  "id": "12daeeac-33a2-4d7a-afb4-e41e019e4ba2",
                  "type": "users",
                  "attributes": {
                      "login-name": "zhangsan3",
                      "name": "张三",
                      "description": "这是一个普通员工",
                      "department": "业务部",
                      "roles": []
                  }
              },
              {
                  "id": "4b3a532a-ce9f-4b39-b488-c36cb7a00704",
                  "type": "users",
                  "attributes": {
                      "login-name": "zhangsan4",
                      "name": "张三",
                      "description": "这是一个普通员工",
                      "department": "业务部",
                      "roles": [
                          "业务部经理"
                      ]
                  }
              }
          ],
          "links": {
              "self": "http://192.168.0.25:3008/v1/users?page%5Bnumber%5D=1&page%5Bsize%5D=2&size=2",
              "next": "http://192.168.0.25:3008/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2&size=2",
              "last": "http://192.168.0.25:3008/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2&size=2"
          },
          "meta": {
              "total-count": 4
          }
      }

### 查看用户详情

    登录 + , 权限 +
    method: get 
    uri: /v1/users/:id
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": {
              "id": "23c3ee17-66e3-4bae-bff4-b6f299a3710d",
              "type": "users",
              "attributes": {
                  "login-name": "zhangsan1",
                  "name": "张三",
                  "description": "这是一个普通员工",
                  "department": "业务部",
                  "roles": [
                      "业务部经理"
                  ]
              }
          }
      }

### 更新用户信息

    登录 + , 权限 +
    method: put 
    uri: /v1/users/:id
    header:
      Content-Type: application/json 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "name": null, //字符串类型的参数，如果没有变化传null值
                "login_name": "zhangsan8",
                "description": "这是一个普通员工",
                "department_id": "dbbbd12c-8629-4ff2-9b3e-711b3652884e",
                "role_id": ["7bb30c91-8894-4f18-bc39-5674635396c3"] //数组类型的参数如果没有变化，传null
          }
        }
      }

      response: 200 成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 删除用户

    登录 + , 权限 +
    method: delete 
    uri: /v1/users/:id
    header:
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 204 成功, 401 token问题， 403 权限问题

### 重置密码

    登录 + , 权限 +
    method: put 
    uri: /v1/users/:id/password
    header:
      Content-Type: application/json 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "password": "12345678"
          }
        }
      }

      response: 200 成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 店员更新个人资料

    登录 + , 权限 +
    method: put 
    uri: /v1/accounts/:id/profile
    header:
      Content-Type: application/json 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "name": null, //没有变化，传null
                "login_name": null,
                "avatar": "data:image/png;base64,...",
                "contact_phone": null
          }
        }
      }

      response: 200 成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 个人修改密码

    登录 + , 权限 +
    method: put 
    uri: /v1/accounts/:id/password
    header:
      Content-Type: application/json 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "original_password": "12345678",
                "password": "12345678",
                "password_confirmation": "12345678"
          }
        }
      }

      response: 200 成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 登录

    method: post 
    uri: /v1/login
    header:
      Content-Type: application/json 
      
    request:
      {
        "data": {
            "type": "users",
            "attributes": {
            "login_name": "admin",
            "password": "12345678"
          }
        }
      }

    response: 200 成功, 401 账号问题

      Authorization →Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsb2dpbl9uYW1lIjoiYWRtaW4iLCJleHAiOjE1MTc5MDE2Mzl9.QHBYAQV_gustCLoi560QQUimTtJYvdWc0Pb8lj2t3-E
     
      {
          "data": {
              "id": "a8928311-a2a4-47fd-bf35-68bec4726c20",
              "type": "users",
              "attributes": {
                  "role": "管理员",
                  "name": "上海维浦信息技术有限公司",
                  "login-name": "admin",
                  "avatar": "/system/users/a8928311-a2a4-47fd-bf35-68bec4726c20/avatars/medium.png?1517814455",
                  "permissions": [
                      "系统管理",
                      "角色管理",
                      "添加角色",
                      "删除角色"
                  ]
              }
          }
      }