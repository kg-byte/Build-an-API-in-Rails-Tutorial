FactoryBot.define do
  factory :item do
    name { Faker::JapaneseMedia::DragonBall.character }
    done { false }
    todo { nil }
  end
end
