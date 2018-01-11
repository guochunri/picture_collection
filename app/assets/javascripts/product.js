$(document).ready(function() {
  var categories;
  $('#product_category_id').parent().show();
  categories = $('#product_category_id').html();
  console.log(categories);
  return $('#product_category_group_id').change(function() {
    var categorygroup, escaped_categorygroup, options;
    categorygroup = $('#product_category_group_id :selected').text();
    escaped_categorygroup = categorygroup.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(categories).filter("optgroup[label=" + escaped_categorygroup + "]").html();
    console.log(options);
    if (options) {
      $('#product_category_id').html(options);
      return $('#product_category_id').parent().show();
    } else {
      $('#product_category_id').empty();
      return $('#product_category_id').parent().hide();
    }
  });
});
