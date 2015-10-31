# Devise User Class
FactoryGirl.define do
  puts "creating factory girl instance."
  factory :user do
    email "basicuser@mvmanor.co.uk"
    password "password1234"
    password_confirmation "password1234"
  end
end


