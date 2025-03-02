FactoryBot.define do
  factory :short_link do
    url { "https://example.com/some-long-path" }
    code { SecureRandom.alphanumeric(6).downcase }
    association :linkable, factory: :user
  end
end
