FactoryGirl.define do
  factory :document do
    title "MyString"
    original_file_name "MyString"
    status "MyString"
    association :owner, factory: :user
  end

end
