class AddDistanceMaxspeedDurationToSession < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :distance, :float
    add_column :sessions, :duration, :float
    add_column :sessions, :maxspeed, :float
  end
end
