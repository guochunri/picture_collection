module Admin::CategoriesHelper

  #显示 Publish/Hidden 状态
  def render_category_status(category)
    if category.is_hidden
      content_tag(:span, "", :class => "fa fa-lock fa-fw")
    else
      content_tag(:span, "", :class => "fa fa-globe fa-fw")
    end
  end

  #显示 Pbulish/Hidden 按钮
  def render_category_publish_or_hide(category)
    if category.is_hidden
      link_to(t('btn-publish'), publish_admin_category_path(category), :method => :post, :class => 'btn btn-sm btn-default')
    else
      link_to(t('btn-hide'), hide_admin_category_path(category), :method => :post, :class => 'btn btn-sm btn-default')
    end
  end
  
end
