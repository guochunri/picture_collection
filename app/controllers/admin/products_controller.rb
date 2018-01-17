class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_CustomerManager!
  before_action :find_product, only: [:show, :update, :destroy, :approve, :unapprove, :last_approved, :last_unapprove]
  layout "admin"
  require 'rubygems'
  require 'zip'

  def index
    if current_user.is_admin?

      @q = Product.ransack(params[:q])
      @products = @q.result.includes(:user, :category_group, :category).recent.page(params[:page]).per(10)

      search_by_created_at

      search_by_state

    elsif current_user.is_manager?

      @q = Product.ransack(params[:q])
      @products = @q.result.joins(:user, :category_group).where("category_groups.user_id" => "#{current_user.id}" ).recent.page(params[:page]).per(10)

      search_by_created_at

      search_by_state

    else

      @q = Product.ransack(params[:q])
      @products = @q.result.joins(:user, :category).where("categories.user_id" => "#{current_user.id}" ).recent.page(params[:page]).per(10)

      search_by_created_at

      search_by_state

    end

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

  def last_approved
    @product.final_agree!
    redirect_to :back
  end

  def last_unapprove
    @product.final_disagree!
    redirect_to :back
  end

  def add_to_zip_file(zip_file_name,file_path)
    def self.add_file(start_path,file_path,zip)
      if File.directory?(file_path)
        zip.mkdir(file_path)
        Dir.foreach(file_path) do |filename|
          add_file("#{start_path}/#{filename}","#{file_path}/#{filename}",zip) unless filename=="." or filename==".."
        end
      else
        zip.add(start_path,file_path)

      end
    end
    if File.exist?(zip_file_name)
      #      puts "文件已存在，将会删除此文件并重新建立。"
      File.delete(zip_file_name)
    end
    # 取得要压缩的目录父路径，以及要压缩的目录名
    chdir,tardir = File.split(file_path)
    # 切换到要压缩的目录
    Dir.chdir(chdir) do
      # 创建压缩文件
      #      puts "开始创建压缩文件"
      Zip::File.open(zip_file_name,Zip::File::CREATE) do |zipfile|
        #        puts "文件创建成功，开始添加文件..."
        # 调用add_file方法，添加文件到压缩文件
        #        puts "已添加文件列表如下:"
        add_file(tardir,tardir,zipfile)
      end
    end
  end

  def download
    picture = []
    @product = Product.find_by_friendly_id!(params[:id])
    FileUtils.mkdir_p("#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}")
    @product.product_images.each do |i|
      picture << i.image.path
    end
    FileUtils.cp(picture, "#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}")

    if (File.exist?("#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}.zip"))
      File.delete("#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}.zip")
    end
    add_to_zip_file("#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}.zip","#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}")
    send_file "#{Rails.root}/public/uploads/temp_dir/#{@product.name.upcase}.zip"
  end

  private

  def find_product
    @product = Product.find_by_friendly_id!(params[:id])
  end

  def search_by_created_at
    if params[:start].present?
     @products = @products.where( "products.created_at >= ?", Date.parse(params[:start]).beginning_of_day )
    end

    if params[:end].present?
     @products = @products.where( "products.created_at <= ?", Date.parse(params[:end]).end_of_day )
    end
  end

  def search_by_state
    if Array(params[:aasm_states]).any?
      @products = @products.by_state(params[:aasm_states])
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :aasm_state, :category_group_id, :category_id)
  end

end
