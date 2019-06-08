FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    trait :with_auth do
      after(:create) do |user, _|
        create(:user_auth, user: user)
      end
    end
  end
end
