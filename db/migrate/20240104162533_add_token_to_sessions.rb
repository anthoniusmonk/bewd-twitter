class AddTokenToSessions < ActiveRecord::Migration[6.1]
  add_column :sessions, :token, :string
  def change
  end
end
