FactoryBot.define do
  factory :address do
    address_line1 { "MyString" }
    address_line2 { "MyString" }
    address_line3 { "MyString" }
    city { "MyString" }
    state { "MyString" }
    postal_code { "MyString" }
    country { "MyString" }
    addressable_id { FactoryBot.create(:user).id }
    addressable_type { "User" }
    created_by { FactoryBot.create(:user).id }
    updated_by { FactoryBot.create(:user).id }
  end
end
