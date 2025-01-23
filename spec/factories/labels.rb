FactoryBot.define do
  factory :label do
    name { "label_test" }
    association :user
  end

  factory :second_label, class: 'Label' do
    name { "label_test2" }
    association :user
  end
end
