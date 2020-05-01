FactoryBot.define do
  factory :task do
    name { "最初のタスク" }
    description { "タスクの説明" }
    deadline { "2020-04-01" }
    status { "未着手" }
    priority { "中" }
  end
end
