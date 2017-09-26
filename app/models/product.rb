class Product < ApplicationRecord
  validates :name, presence: { message: "请输入商品名称" }
  validates :category_id, presence: { message: "请选择商品分类" }

  belongs_to :category
  belongs_to :user
end
