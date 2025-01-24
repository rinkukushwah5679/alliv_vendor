class AddressSerializer < BaseSerializer
  attributes :id, :address_line1, :address_line2, :address_line3, :city, :state, :postal_code, :country, :address_type, :created_at, :updated_at

  attribute :created_by do |object|
    object.creator
  end

  attribute :updated_by do |object|
    object.updater
  end
end
