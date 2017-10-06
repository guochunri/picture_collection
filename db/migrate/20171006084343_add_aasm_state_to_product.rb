class AddAasmStateToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :aasm_state, :string, default: "waitting_for_approval"
    add_index  :products, :aasm_state
  end
end
