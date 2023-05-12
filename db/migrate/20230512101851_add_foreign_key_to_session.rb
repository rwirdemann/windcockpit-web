class AddForeignKeyToSession < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :sessions, :spots
  end
end
