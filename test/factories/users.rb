FactoryBot.define do
  factory :user do
    # Define attributes for user here
    # For example:
    email_address { "user#{SecureRandom.hex(4)}@example.com" }
    password { "password123" }
  end
end
