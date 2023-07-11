class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :type , :null => false
      t.string :name
      t.string :username
      t.string :password
      t.integer :mobile

      t.timestamps
    end
  end
end
