class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  layout "admin"

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def approve
    @product = Product.find(params[:id])
    @product.agree!
    redirect_to :back
  end

  def unapprove
    @product = Product.find(params[:id])
    @product.disagree!
    redirect_to :back
  end

end
