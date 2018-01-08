class AddUserIdToCategoryGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :category_groups, :user_id, :integer
  end
end
