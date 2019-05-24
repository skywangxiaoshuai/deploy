### 字段说明

    level（角色等级）: admin 管理员， company_leader 公司领导， department_leader 部门领导， employee 一线员工
    org_type（机构类型）: platform 运营商，agent 代理商, merchant 商户
    name (角色名称)
    description (描述)
    is_disabled (状态，false为启用，true为禁用)
    permissions (权限)

### 添加角色

    登录 + , 权限 +
    method: post
    uri: /v1/roles
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "name": "店员",
                "org_type": "merchant",
                "level": "employee",
                "description": "店员"
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 更新角色

    登录 + , 权限 +
    method: put
    uri: /v1/roles/:id
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "name": "店员",
                "org_type": "merchant",
                "level": "employee",
                "description": null  //如果某些字段没有变化，前端传null值
          }
        }
      }

    response: 200 更新成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 查看各级平台相对应的角色，使用场景：添加用户时选择角色， 没有分页

    登录 + , 权限 +
    method: get
    uri: /v1/relative_roles
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": [
              {
                  "id": "37bea24a-58cc-409e-9b1a-0394238eee1a",
                  "type": "roles",
                  "attributes": {
                      "name": "管理员",
                      "org-type": "platform",
                      "level": "admin",
                      "description": "平台管理员"
                  }
              },
              {
                  "id": "d0cd40c0-43f7-4592-affa-aeb3829f00c1",
                  "type": "roles",
                  "attributes": {
                      "name": "CEO",
                      "org-type": "platform",
                      "level": "company_leader",
                      "description": "公司CEO"
                  }
              },
              {
                  "id": "34cea387-f250-41c2-950a-f26f3c5da398",
                  "type": "roles",
                  "attributes": {
                      "name": "业务部经理",
                      "org-type": "platform",
                      "level": "department_leader",
                      "description": "业务部经理"
                  }
              },
              {
                  "id": "045c651b-e6f2-44d5-86ce-6633e8158cd2",
                  "type": "roles",
                  "attributes": {
                      "name": "业务员",
                      "org-type": "platform",
                      "level": "employee",
                      "description": "业务员"
                  }
              },
              {
                  "id": "78cc5166-483f-484b-a70d-730ae64c12ee",
                  "type": "roles",
                  "attributes": {
                      "name": "管理员",
                      "org-type": "agent",
                      "level": "admin",
                      "description": "代理商管理员"
                  }
              },
              {
                  "id": "c9acf2e7-3e5f-43e5-bfb2-21e9a91c94fb",
                  "type": "roles",
                  "attributes": {
                      "name": "CEO",
                      "org-type": "agent",
                      "level": "company_leader",
                      "description": "公司CEO"
                  }
              },
              {
                  "id": "7bb30c91-8894-4f18-bc39-5674635396c3",
                  "type": "roles",
                  "attributes": {
                      "name": "业务部经理",
                      "org-type": "agent",
                      "level": "department_leader",
                      "description": "业务部经理"
                  }
              },
              {
                  "id": "e7752de4-1b74-4828-8212-21745a3c415d",
                  "type": "roles",
                  "attributes": {
                      "name": "业务员",
                      "org-type": "agent",
                      "level": "employee",
                      "description": "业务员"
                  }
              },
              {
                  "id": "441f5b52-d96e-4083-9ef4-5f905f50c007",
                  "type": "roles",
                  "attributes": {
                      "name": "管理员",
                      "org-type": "merchant",
                      "level": "admin",
                      "description": "商户管理员"
                  }
              },
              {
                  "id": "810741e3-3eec-4295-a4fa-cb2bef15d71d",
                  "type": "roles",
                  "attributes": {
                      "name": "店长",
                      "org-type": "merchant",
                      "level": "department_leader",
                      "description": "店长"
                  }
              },
              {
                  "id": "e86f8a0e-0c5d-4e28-8fde-0290f57f5acb",
                  "type": "roles",
                  "attributes": {
                      "name": "店员",
                      "org-type": "merchant",
                      "level": "employee",
                      "description": "店员"
                  }
              }
          ]
      } 


### 查看所有角色，有分页

    登录 + , 权限 +
    method: get
    uri: /v1/roles?page=1&size=2
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....


    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": [
              {
                  "id": "37bea24a-58cc-409e-9b1a-0394238eee1a",
                  "type": "roles",
                  "attributes": {
                      "name": "管理员",
                      "org-type": "platform",
                      "is-disabled": false,
                      "level": "admin",
                      "description": "平台管理员",
                      "permissions": [
                          "系统管理",
                          "角色管理",
                          "添加角色",
                          "删除角色"
                      ]
                  }
              },
              {
                  "id": "d0cd40c0-43f7-4592-affa-aeb3829f00c1",
                  "type": "roles",
                  "attributes": {
                      "name": "CEO",
                      "org-type": "platform",
                      "is-disabled": false,
                      "level": "company_leader",
                      "description": "公司CEO",
                      "permissions": []
                  }
              }
          ],
          "links": {
              "self": "http://192.168.0.25:3008/v1/roles?page%5Bnumber%5D=1&page%5Bsize%5D=2&size=2",
              "next": "http://192.168.0.25:3008/v1/roles?page%5Bnumber%5D=2&page%5Bsize%5D=2&size=2",
              "last": "http://192.168.0.25:3008/v1/roles?page%5Bnumber%5D=6&page%5Bsize%5D=2&size=2"
          },
          "meta": {
              "total-count": 11
          }
      }

### 查看角色详情

    登录 + , 权限 +
    method: get
    uri: /v1/roles/:id 
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....


    response: 200 成功, 401 token问题， 403 权限问题
      {
          "data": {
              "id": "37bea24a-58cc-409e-9b1a-0394238eee1a",
              "type": "roles",
              "attributes": {
                  "name": "管理员",
                  "org-type": "platform",
                  "level": "admin",
                  "description": "平台管理员"
              }
          }
      }

### 删除角色

    登录 + , 权限 +
    method: delete
    uri: /v1/roles/:id 
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....


    response: 204 成功, 401 token问题， 403 权限问题
      
### 启用/停用角色

    登录 + , 权限 +
    method: delete
    uri: 
      启用: /v1/roles/:id/enable_role
      停用: /v1/roles/:id/disable_role
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....


    response: 200 成功, 401 token问题， 403 权限问题

### 角色授权

    登录 + , 权限 +
    method: put
    uri: /v1/roles/:id/permissions
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "users",
             "attributes": {
                "permissions": [
                  "15d29e18-a5b1-4214-9ac1-c9d7d1e86e57", 
                  "4b101ffa-39ad-4106-8729-0986d4956179", 
                  "cf720b32-f091-4d46-a676-d15bca3f08a8", 
                  "ff47cb1d-f5a9-4a36-a557-11fa419bbff5"
                ]
          }
        }
      }

    response: 200 授权成功, 401 token问题， 403 权限问题， 422 参数验证问题