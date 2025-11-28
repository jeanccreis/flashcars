class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :model, null: false
      t.string :brand, null: false
      t.integer :year, null: false
      t.string :color, null: false

      t.timestamps
    end

    add_index :cars, :brand
    add_index :cars, :year
  end
end
