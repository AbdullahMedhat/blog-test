FactoryBot.define do
  factory :post do
    title       { Faker::Name.first_name }
    content { Faker::Lorem.paragraph }
  end
end
