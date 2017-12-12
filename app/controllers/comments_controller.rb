class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:create]

  def create
    @comment = @product.comments.create(params[:comment].permit(:comment))
    @comment.user_id = current_user.id if current_user
    @comment.save

    if @comment.save
      redirect_to product_path(@product)
    else
      render 'new'
    end
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

end
