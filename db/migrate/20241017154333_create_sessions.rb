class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
