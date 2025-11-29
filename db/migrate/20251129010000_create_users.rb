class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :plan, null: false, default: 'free'
      t.timestamps
    end

    add_index :users, :plan
  end
end
