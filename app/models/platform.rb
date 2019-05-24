class Platform < ApplicationRecord
  has_many :users, as: :userable
  has_many :agents
end
