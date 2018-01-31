class Admin::ProductImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_CustomerManager!
  before_action :find_product, only: [:chosen, :destroy]
  layout "admin"

  # 精选
  def chosen
    @product_image = @product.product_images.find(params[:id])

    if @product_image.is_chosen == true
      @product_image.no_chosen!
    else
      @product_image.chosen!
    end

    redirect_to :back
  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    @product_image.destroy
    redirect_to :back
  end

  private

  def find_product
    @product = Product.find_by_friendly_id!(params[:product_id])
  end

end
