FactoryGirl.define do
  factory :document do
    title "Factory Document 1"
    original_file_name "Original File Name"
    status "New"
    association :owner, factory: :user
  end

end
