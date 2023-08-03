class CreateClocks < ActiveRecord::Migration[7.0]
  def change
    create_table :clocks do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamp :clock_in, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :clock_out
      t.integer :duration
    end
  end
end
