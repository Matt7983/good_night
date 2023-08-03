class Follower < ApplicationRecord
  self.primary_keys = :followee_id, :follower_id

end
