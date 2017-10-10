class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @products = Product.order("created_at DESC").page(params[:page]).per(12)
  end

  def show
    @product_images = @product.product_images.all
  end

  def new
    @product = current_user.products.build
    @product_image = @product.product_images.build
    @category_groups = CategoryGroup.published
    @categories = Category.published.order("category_group_id, name")
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      if params[:product_images] != nil
        params[:product_images]['image'].each do |i|
          @product_image = @product.product_images.create(:image => i)
        end
      end
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
    @category_groups = CategoryGroup.published.map { |g| [g.name, g.id] }
    @categories = Category.published.order("category_group_id, name")
  end

  def update
    @category_groups = CategoryGroup.published.map { |g| [g.name, g.id] }
    @categories = Category.published.map { |c| [c.name, c.id] }
    @product.update_product!

    if params[:product_images] != nil
      @product.product_images.destroy_all

      params[:product_images]['image'].each do |i|
        @product_image = @product.product_images.create(:image => i)
      end
      @product.update(product_params)
      redirect_to @product
    elsif @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to root_path
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :category_group_id, :category_id)
  end

end
