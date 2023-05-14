class AddWhenToSession < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :when, :date
  end
end
