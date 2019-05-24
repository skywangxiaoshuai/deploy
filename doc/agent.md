### 添加代理商

    登录 + , 权限 +
    method: post
    uri: /v1/agents
    header: 
      Content-Type: application/json
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    request:
      {
        "data": {
          "type": "agents",
             "attributes": {
             	  "agent_type": "personal",
                "name": "锤子科技有限公司7",
                "short_name": "锤子7",
                 "users_attributes": [
                	{
                		 "login_name": "witspool7",
              		 "password": "123456a"
                	}
                	
                ]
          }
        }
      }

    response: 201 创建成功, 401 token问题， 403 权限问题， 422 参数验证问题

### 查看代理商列表
    
    登录 + , 权限 +
    method: get
    uri: /v1/agents?page=1&size=2
    header: 
      Authorization: Bearer eyJ0eXAiOiJKV1Qi....

    response:
      {
        "data": [
            {
                "id": "728b28ff-9f71-4d1d-8769-5e2673772d0a",
                "type": "agents",
                "attributes": {
                    "short-name": null,
                    "agent-type": null,
                    "is-disabled": false, #false为启用， true为禁用
                    "audit": "verified" # verified审核成功, verifing, reject审核失败
                }
            },
            {
                "id": "83513224-6c1d-49d9-9923-704d36a00e00",
                "type": "agents",
                "attributes": {
                    "short-name": "锤子2",
                    "agent-type": "personal", 
                    "is-disabled": false,
                    "audit": "verified"
                }
            }
        ],
        "links": {},
        "meta": {
            "total-count": 2
        }
    }