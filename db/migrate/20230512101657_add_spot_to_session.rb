class AddSpotToSession < ActiveRecord::Migration[7.0]
  def change
    add_reference :sessions, :spot
  end
end
