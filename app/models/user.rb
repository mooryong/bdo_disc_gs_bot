class User < ActiveRecord::Base
  has_many :characters, foreign_key: :discord_id, primary_key: :discord_id
end