FactoryBot.define do
  factory :element do
    tag { "para" }
    content { "Hello world!" }
    identifier { "ch01_1" }
  end
end
