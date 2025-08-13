FactoryBot.define do
  factory :post do
    title { "Sample Post Title" }
    description { "Sample post description" }
    content { "Sample post content" }
    published_at { Time.current }
    status { :published }
    views_count { 0 }

    association :user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
      published_at { Time.current }
    end

    trait :archived do
      status { :archived }
    end
  end
end
