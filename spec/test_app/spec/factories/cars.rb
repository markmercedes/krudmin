FactoryBot.define do
  factory :car do
    model { FFaker::Name.name }
    year { (2000..2010).to_a.sample }
    association :car_brand
    description { FFaker::Lorem.sentence }
  end
end
