FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name {"Aaron"}
    last_name {"Sumner"}
    sequence(:email) {|n|"tester#{n}@example.com"}
    password {"dottle-nouveau-pavilion-tights-furze"}
    
    trait :joe do 
      first_name {"Jae"}
      last_name {"Tester"}
      sequence(:email) {|n|"joe_tester#{n}@example.com"}
      password {"dottle-nouveau-pavilion-tights-furze"}
    end
  end
end
