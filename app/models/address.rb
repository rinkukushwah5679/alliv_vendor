class Address < ApplicationRecord
	enum address_type: %w(Primary Alternate)
	belongs_to :addressable, polymorphic: true
end
