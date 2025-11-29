class AddPlanToApiKeys < ActiveRecord::Migration[7.1]
  def change
    add_column :api_keys, :plan, :string, null: false, default: 'free'
    add_index :api_keys, :plan
  end
end
