class Admin::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  before_action :find_product, only: [:create, :edit, :update, :destroy]
  layout "admin"

  def create
    @comment = @product.comments.create(params[:comment].permit(:comment))
    @comment.user_id = current_user.id if current_user
    @comment.save

    if @comment.save
      redirect_to admin_product_path(@product)
    else
      render 'new'
    end
  end

  def edit
    @comment = @product.comments.find(params[:id])
  end

  def update
    @comment = @product.comments.find(params[:id])

    if @comment.update(params[:comment].permit(:comment))
      redirect_to admin_product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = @product.comments.find(params[:id])
    @comment.destroy
    redirect_to admin_product_path(@product)
  end

  private

  def find_product
    @product = Product.find_by_friendly_id!(params[:product_id])
  end

end
