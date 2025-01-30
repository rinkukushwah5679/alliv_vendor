class BusinessDetailsSerializer < BaseSerializer
  attributes :id, :busi_name, :first_name, :last_name, :office_address, :phone, :email, :fein_or_tin_number

  attribute :business_logo do |object|
    object.business_logo_url
  end
end
