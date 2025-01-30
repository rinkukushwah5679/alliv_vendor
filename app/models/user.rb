class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # default_scope { order(created_at: :desc) }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # attr_accessor :current_password
  has_one_attached :profile_pic
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  validates :first_name, :last_name, presence: true
  after_save :check_profile_pic_upload, if: -> { profile_pic.attached? && saved_change_to_profile_pic? }

  # this is required only (association owner(PropertyOwner))
  # enum mailing_preference: %w(PrimaryAddress AlternateAddress)
  # enum mailing_preference: { PrimaryAddress: "PrimaryAddress", AlternateAddress: "AlternateAddress" }

  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :emergency_contact, dependent: :destroy
  has_one :business_detail, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def activated
    is_active ? "Activate" : "Deactivate"
  end

  private
  def check_profile_pic_upload
    if profile_pic.attached?
      public_url = generate_public_url(profile_pic)
      update_column(:profile_pic_url, public_url)
    end
  end

  def generate_public_url(attachment)
    "https://" + "#{ENV['AWS_BUCKET']}" + ".s3." + "#{ENV['AWS_RESION']}" + ".amazonaws.com/" + "#{attachment.blob.key}"
  end

  def saved_change_to_profile_pic?
    attachment_changes['profile_pic'].present?
  end
end