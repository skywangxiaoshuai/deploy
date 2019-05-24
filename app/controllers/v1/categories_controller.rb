class V1::CategoriesController < ApplicationController
  before_action :get_current_user

  #获取商户类型
  #get /v1/categories/:id/sub_categories
  def get_sub_categories
    #权限验证
    authorize Category
    category = Category.find_by(id: params[:id])
    categories = category.children
    render status: 200, json: categories, each_serializer: CategorySerializer
  end
end
