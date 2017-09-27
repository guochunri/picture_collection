class AddCategoryGroupIdToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :category_group_id, :integer
  end
end
