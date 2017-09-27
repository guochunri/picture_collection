class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @products = Product.all.order("created_at DESC")
  end

  def show
  end

  def new
    @product = current_user.products.build
    @categories = Category.all.order("category_group_id, name")
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
    @categories = Category.all.order("category_group_id, name")
  end

  def update
    @categories = Category.all.map { |c| [c.name, c.id] }

    if @product.update(product_params)
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
    params.require(:product).permit(:name, :description, :category_id)
  end

end
