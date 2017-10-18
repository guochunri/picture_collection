class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  before_action :validate_search_key, only: [:search]
  layout "admin"

  def index
    @products = Product.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])
    @product_images = @product.product_images.all
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path
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

  def search
    if @query_string.present?
       search_result = Product.joins(:user).ransack(@search_criteria).result(:distinct => true)
       @products = search_result.page(params[:page]).per(10)
     end
  end

  protected

  def validate_search_key
    @query_string = params[:keyword].gsub(/\\|\'|\/|\?/, "") if params[:keyword].present?
    @search_criteria = search_criteria(@query_string)
  end

  def search_criteria(query_string)
    { name_or_user_name_cont: query_string }
  end

end
