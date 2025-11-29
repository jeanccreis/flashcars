class CreateApiKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :api_keys do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :name, null: false
      t.datetime :revoked_at
      t.datetime :last_used_at
      t.timestamps
    end
  end
end
