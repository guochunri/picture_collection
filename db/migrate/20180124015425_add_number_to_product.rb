class AddNumberToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :number, :integer
  end
end
