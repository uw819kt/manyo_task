FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、その
  # クラスのテストデータが作成されます
  factory :task do
    title { 'first_task' }
    content { '企画書を作成する。' }
    deadline_on { Date.new(2022, 2, 18) }
    priority { '中' }
    status { "未着手" }
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする
  # 場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'second_task' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.new(2022, 2, 17) }
    priority { '高' }
    status { "着手中" }  
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'ステップ1まで' }
    deadline_on { Date.new(2022, 2, 16) }
    priority { '低' }
    status { "完了" }  
  end
end
