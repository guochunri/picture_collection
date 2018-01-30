class Product < ApplicationRecord
  validates :name, presence: { message: "请输入车牌号码" }
  validates :category_id, presence: { message: "请选择所属分类" }
  validates :number, presence: { message: "请输入补漆数量" }

  belongs_to :category_group
  belongs_to :category
  belongs_to :user
  has_many :product_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :product_images
  before_validation :generate_friendly_id, :on => :create

  has_many :likes, :dependent => :destroy
  has_many :liked_users, :through => :likes, :source => :user

  def find_like(user)
    self.likes.where( :user_id => user.id ).first
  end

  scope :recent, -> { order("created_at DESC") }
  scope :by_state, ->(s){ where( :aasm_state => s ) }

  def to_param
    self.friendly_id
  end

  protected

  def generate_friendly_id
    self.friendly_id ||= SecureRandom.uuid
  end

  include AASM

  aasm do
    state :waitting_for_approval, initial: true
    state :approved
    state :final_approved
    state :rejected
    state :final_rejected

    event :agree do
      transitions from: :waitting_for_approval,         to: :approved
    end

    event :disagree do
      transitions from: :waitting_for_approval,     to: :rejected
    end

    event :final_agree do
      transitions from: :approved,         to: :final_approved
    end

    event :final_disagree do
      transitions from: :approved,         to: :final_rejected
    end

    event :update_product do
      transitions from: [:waitting_for_approval, :approved, :rejected, :final_approved, :final_rejected], to: :waitting_for_approval
    end
  end

end
