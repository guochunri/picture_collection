class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :products
  has_many :comments
  has_one :category_group
  has_one :category

  scope :recent, -> { order("created_at DESC") }

  ROLES = ["admin", "CustomerManager", "CustomerOperator", "ordinary"]

  def is_admin?
    self.role == "admin"
  end

  def is_manager?
    self.role == "CustomerManager"
  end

  def is_operator?
    self.role == "CustomerOperator"
  end

  def is_CustomerManager?
    ["admin", "CustomerManager", "CustomerOperator"].include?(self.role)  # 如果是 admin 的话，当然也有 CustomerManager 的权限
  end

end
