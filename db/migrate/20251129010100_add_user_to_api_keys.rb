class AddUserToApiKeys < ActiveRecord::Migration[7.1]
  def change
    add_reference :api_keys, :user, null: false, foreign_key: true, index: true
    remove_column :api_keys, :plan, :string
  end
end
