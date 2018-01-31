class AddIsChosenToProductImages < ActiveRecord::Migration[5.0]
  def change
    add_column :product_images, :is_chosen, :boolean, default: false
  end
end
