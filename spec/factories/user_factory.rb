# Devise User Class
FactoryGirl.define do
  factory :user do
    first_name "Factory"
    last_name "Girl"
    email "basicuser@mvmanor.co.uk"
    password "password1234"
    password_confirmation "password1234"
    account_type "writer"
  end
end


