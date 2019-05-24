class V1::PermissionsController < ApplicationController
  before_action :get_current_user, only: [:index]

  #查看权限列表，不同的用户有不同的权限列表
  #get /v1/permissions
  def index
    #验证当前用户有没有查看权限列表的权限
    # authorize Permission
    #取出当前用户的所有的权限
    permissions = @current_user.permissions
    render status: 200, json: permissions, each_serializer: PermissionSerializer
  end
end
