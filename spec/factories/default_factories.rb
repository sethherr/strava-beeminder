FactoryGirl.define do

  factory :user do 
    sequence(:email) {|n| "user#{n}@example.com"}
    password 'some_pass69'
  end

end