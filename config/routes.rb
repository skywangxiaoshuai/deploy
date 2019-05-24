Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :users, except: [:new, :edit]
    post '/login', to: 'users#login'
    put '/users/:id/password', to: 'users#reset_password'
    put '/accounts/:id/profile', to: 'users#update_profile'
    put '/accounts/:id/password', to: 'users#modify_password'


    get '/permissions', to: 'permissions#index'

    resources :roles, except: [:new, :edit]
    get '/relative_roles', to: 'roles#get_relative_roles'
    put '/roles/:id/disable_role', to: 'roles#disable_role'
    put '/roles/:id/enable_role', to: 'roles#enable_role'
    put '/roles/:id/permissions', to: 'roles#add_permissions'

    post '/payment_methods', to: 'payment_methods#create'
    get '/payment_methods', to: 'payment_methods#index'

    post '/payment_channels', to: 'payment_channels#create'
    get '/payment_channels', to: 'payment_channels#index'
    get '/payment_methods/:id/payment_channels', to: 'payment_channels#get_payment_method_channels'
    post '/payment_channel/:id/payment_methods', to: 'payment_channels#configurate_channel'


    post '/agents', to: 'agents#create'
    get '/agents', to: 'agents#index'

    get '/categories/:id/sub_categories', to: 'categories#get_sub_categories'

    post '/merchants', to: 'merchants#create'
    get '/merchants/search_by_name', to: 'merchants#search_by_name'

    post '/stores', to: 'stores#create_store'
    get '/stores', to: 'stores#index_stores'
    get '/stores/:id', to: 'stores#get_store_by_id'
    put '/stores/:id', to: 'stores#update_store'
    post '/stores/:id/users', to: 'stores#create_user'
    get '/stores_users', to: 'stores#index_stores_users'
    get '/store_users/:id', to: 'stores#get_store_user_by_id'
    put '/store_users/:id', to: 'stores#update_store_user'

    post '/stores/:id/store_devices', to: 'department_devices#bind_device'
    get '/stores/:id/store_devices', to: 'department_devices#index_devices'
    delete '/store_devices/:id', to: 'department_devices#unbind_device'

    post '/payment_accounts', to: 'payment_accounts#create'
    get '/payment_accounts', to: 'payment_accounts#index'

    post '/payment_method_channels', to: 'payment_method_channels#create'
    get '/payment_method_channels', to: 'payment_method_channels#index'



    #支付相关
    #测试
    get '/alipay', to: 'wechat_pay#alipay'
    post '/wechat_micropay', to: 'wechat_pay#invoke_micropay'
    get '/orders/query_order', to: 'wechat_pay#query_order'
    get '/orders/reverse_order', to: 'wechat_pay#reverse_order'
    #测试

    #扫码收款
    post '/gathering', to: 'pays#make_collections'
    #退款
    post '/refund', to: 'pays#refund'
    #微信退款异步通知
    post '/wechat_refund/notification', to: 'pays#wechat_refund_notification'
    #微信扫码付款
    post '/wechat_payment', to: 'pays#wechat_payment'
    #微信扫码付款结果异步通知
    post '/wechat_payment/notification', to: 'pays#wechat_payment_notification'
    #获取支付宝商户授权token
    get '/ali_auth_token', to: 'pays#get_ali_auth_token'
    #支付宝扫码付款
    post '/alipay_payment', to: 'pays#alipay_payment'
    #支付宝扫码付款异步通知
    post '/alipay_payment/notification', to: 'pays#alipay_payment_notification'
  end
end
