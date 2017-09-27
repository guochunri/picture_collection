class Category < ApplicationRecord
  validates :name, presence: { message: "请输入分类名称" }
  validates :category_group_id, presence: { message: "请选择分类类型" }

  belongs_to :category_group
  has_many :products

  scope :published, -> { where(is_hidden: false) }

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end
  
end
