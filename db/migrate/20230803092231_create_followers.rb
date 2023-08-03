class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers, primary_key: [:follower_id, :followee_id] do |t|
      t.integer :followee_id, null: false
      t.integer :follower_id, null: false
      t.timestamp :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :followers, :followee_id
  end
end
