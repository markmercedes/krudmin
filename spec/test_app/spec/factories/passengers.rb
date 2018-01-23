FactoryBot.define do
  factory :passenger do
    name { FFaker::Name.name }
    age { (2000..2010).to_a.sample }
    gender { (0..1).to_a.sample }
    association :car
  end
end
