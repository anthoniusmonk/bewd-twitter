class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|

      t.timestamps null: false
    end
  end
end
