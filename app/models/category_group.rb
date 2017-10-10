class CategoryGroup < ApplicationRecord
  validates :name, presence: true
  has_many :categories
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
