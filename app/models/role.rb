class Role < ApplicationRecord
	# VALID_ROLES = %w[Resident Vendor SystemAdmin BoardMember AssociationManager PropertyOwner PropertyManager Tenant]

  # validates :name, inclusion: { 
  #   in: VALID_ROLES, 
  #   message: ->(object, data) { "#{data[:value]} this role not acceptable" } 
  # }, if: -> { name.present? }
	# validates :name, presence: true
	# validates :name, uniqueness: { case_sensitive: false, message: lambda{|x, y| "#{y[:value]} is already present" }}
	has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
end
