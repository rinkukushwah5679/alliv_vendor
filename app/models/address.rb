class Address < ApplicationRecord
	enum address_type: { Primary: 0, Alternate: 1 }
	validates :address_line1, :country, presence: true
	belongs_to :addressable, polymorphic: true
	belongs_to :creator, class_name: "User", foreign_key: :created_by
	belongs_to :updater, class_name: "User", foreign_key: :updated_by
end
