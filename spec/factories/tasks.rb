FactoryBot.define do
  factory :task do
    name { "最初のタスク" }
    description { "タスクの説明" }
    deadline { "2020-04-01 00:00:00 +0900" }
  end
end
