class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  layout "admin"

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    @category_groups = CategoryGroup.all.map { |g| [g.name, g.id] }
  end

  def create
    @category = Category.new(category_params)
    @category.category_group_id = params[:category_group_id]

    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
    @category_groups = CategoryGroup.all.map { |g| [g.name, g.id] }
  end

  def update
    @category = Category.find(params[:id])
    @category.category_group_id = params[:category_group_id]

    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :category_group_id, :is_hidden)
  end

end
