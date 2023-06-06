class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.belongs_to :user
      t.belongs_to :session
      t.float :distance
      t.float :duration
      t.float :maxspeed
      t.datetime :tracked_at
      t.timestamps
    end
  end
end
