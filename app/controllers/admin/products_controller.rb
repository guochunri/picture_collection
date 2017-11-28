class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  before_action :validate_search_key, only: [:search]
  before_action :find_product, only: [:show, :update, :destroy, :approve, :unapprove]
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
    @product = Product.find(params[:id])
    FileUtils.mkdir_p("#{Rails.root}/public/uploads/temp_dir/#{@product.name}")
    @product.product_images.each do |i|
      picture << i.image.path
    end
    FileUtils.cp(picture, "#{Rails.root}/public/uploads/temp_dir/#{@product.name}")

    if (File.exist?("#{Rails.root}/public/uploads/temp_dir/#{@product.name}.zip"))
      File.delete("#{Rails.root}/public/uploads/temp_dir/#{@product.name}.zip")
    end
    add_to_zip_file("#{Rails.root}/public/uploads/temp_dir/#{@product.name}.zip","#{Rails.root}/public/uploads/temp_dir/#{@product.name}")
    send_file "#{Rails.root}/public/uploads/temp_dir/#{@product.name}.zip"
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
