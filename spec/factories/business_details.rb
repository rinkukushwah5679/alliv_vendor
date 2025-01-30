FactoryBot.define do
  factory :business_detail do
    busi_name { Faker::Company.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    office_address { "MyString" }
    phone { "MyString" }
    email { Faker::Internet.email }
    fein_or_tin_number { "MyString" }
    user_id { FactoryBot.create(:user).id }
    association_id { "" }
    created_by { "" }
    updated_by { "" }
  end
end
