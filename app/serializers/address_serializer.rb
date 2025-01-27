class AddressSerializer < BaseSerializer
  attributes :id, :address_line1, :address_line2, :address_line3, :city, :state, :postal_code, :country, :address_type, :created_at, :updated_at

  attribute :created_by do |object|
    {id: object.c_id, email: object.c_email}
  end

  attribute :updated_by do |object|
    # object.updater
    {id: object.up_id, email: object.up_email}
  end
end
