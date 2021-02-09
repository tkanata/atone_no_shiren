FactoryBot.define do
  factory :post do
    card_info { Faker::Name.name }
  end
end
