class AddVisibilityToSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :visibility, :string, null: false, :default => "private"
  end
end
