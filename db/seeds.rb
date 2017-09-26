# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 新增大分类 - CategoryGroup #
CategoryGroup.create!(
  name: '人寿保险'
)

CategoryGroup.create!(
  name: '平安保险'
)

puts '创建大分类*2'

# 新增分类 - Category #

Category.create!(
  name: '补漆',
  category_group_id: 1
)

Category.create!(
  name: '美容',
  category_group_id: 2
)

puts '创建分类*2'
