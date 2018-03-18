FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    age { (1960..2018).to_a.sample }
    gender { (0..1).to_a.sample }
    email { FFaker::Internet.email}
    association :car
  end
end
