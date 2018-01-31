class ProductImage < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :product

  # 精选
  def chosen!
    self.is_chosen = true
    self.save
  end

  def no_chosen!
    self.is_chosen = false
    self.save
  end

end
