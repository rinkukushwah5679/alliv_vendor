class Address < ApplicationRecord
	enum address_type: { Primary: 0, Alternate: 1 }
	validates :address_line1, :country, presence: true
	belongs_to :addressable, polymorphic: true
	belongs_to :creator, class_name: "User", foreign_key: :created_by
	belongs_to :updater, class_name: "User", foreign_key: :updated_by
	# after_save :update_other_addresses_to_alternate, if: :primary_address?
  after_save :ensure_only_one_primary

	private
  # def primary_address?
  # 	if saved_change_to_address_type?
  # 	end
  #   saved_change_to_attribute?(:address_type) && Primary?
  # end

  # def update_other_addresses_to_alternate
  #   addressable.addresses.where.not(id: id).update_all(address_type: :Alternate)
  # end

  def ensure_only_one_primary
    if Primary?
      addressable.addresses.where.not(id: id).update_all(address_type: :Alternate)
    end
  end
end
