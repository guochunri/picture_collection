class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  before_action :validate_search_key, only: [:search]
  before_action :find_product, only: [:show, :update, :destroy, :approve, :unapprove, :download]
  layout "admin"
  require 'rubygems'
  require 'zip'

  def index
    @products = Product.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @product_images = @product.product_images.all
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path
  end

  def approve
    @product.agree!
    redirect_to :back
  end

  def unapprove
    @product.disagree!
    redirect_to :back
  end

  def download
    files =  @product.tap{ |product| [product.product_images.first.image.url, product.product_images.first.image.url.split("/").last] }
    @download_link = "uploads/#{@product.name}_#{Time.now.to_i}.zip"
    Zip::File.open("public/#{@download_link}", Zip::File::CREATE) do |zipfile|

      zipfile.add(@product.product_images.first.image.url.split("/").last, @product.product_images.first.image.path)
    end

    send_file Rails.root.join('public', "#{@download_link}")
  end

  def search
    if @query_string.present?
       search_result = Product.joins(:user).ransack(@search_criteria).result(:distinct => true)
       @products = search_result.page(params[:page]).per(10)
     end
  end

  private

  def find_product
    @product = Product.find(params[:id])
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
