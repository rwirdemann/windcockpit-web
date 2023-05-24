class AddUserRefToSessions < ActiveRecord::Migration[7.0]
  def change
    add_reference :sessions, :user, foreign_key: true
    Session.find_each do |session|
      session.user = User.first
      session.save!
    end
  end
end
