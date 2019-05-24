class V1::AgentsController < ApplicationController
  before_action :get_current_user
  before_action :set_agent, only: [:show, :update, :destroy]

  #查询代理商
  #get /v1/search_agents?q1=xx&q2=xx
  def search

  end

  #查看代理商列表
  #get /v1/agents?page=1&size=2
  def index
    #验证当前用户有没有添加代理商的权限
    authorize Agent
    page = params[:page] ? params[:page] : 1
    agents = Agent.ransack(audit_eq: params[:audit]).result.page(page).per(params[:size])
    render status: 200, json: agents, meta: pagination_dict(agents), each_serializer: AgentSerializer
  end

  #查看代理商详情
  #get /v1/agents/:id
  def show
    #验证权限
    authorize Agent
    render status: 200, json: @agent, serializer: AgentInfoSerializer
  end

  #添加代理商
  #post /v1/agents
  def create
    #验证当前用户有没有添加代理商的权限
    authorize Agent
    #取出当前用户的运营平台信息
    platform = @current_user.userable
    parameters = agent_params
    parameters[:server_id] = @current_user.id
    agent = platform.agents.new(parameters)
    # binding.pry
    if agent.save
      #查出代理商管理员角色
      role = Role.find_by(level: 0, org_type: 2)
      user = agent.users.where(is_admin: true).first
      user.roles << role #为用户添加代理商管理员的角色
      render status: 201
    else
      render_422(agent)
    end
  end

  private

  def agent_params
    parameters = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:agent_type, :short_name, :name, :users_attributes])
    parameters[:audit] = 'verified'
    parameters[:users_attributes][0][:audit] = 'verified'
    parameters[:users_attributes][0][:password_confirmation] = parameters[:users_attributes][0][:password]
    parameters[:users_attributes][0][:is_admin] = true
    parameters
  end

  def render_422(json)
    return render status: 422, json: json, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def set_agent
    @agent = Agent.find_by(id: params[:id])
    return render status: 404 unless @agent
  end
end
