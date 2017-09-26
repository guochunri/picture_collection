class Category < ApplicationRecord
  validates :name, presence: { message: "请输入分类名称" }
  validates :category_group_id, presence: { message: "请选择分类类型" }

  belongs_to :category_group
  has_many :products
end
