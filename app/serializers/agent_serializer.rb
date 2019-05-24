class AgentSerializer < ActiveModel::Serializer
  attributes :id, :short_name, :agent_type, :is_disabled, :audit
end
