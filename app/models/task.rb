class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
end

# 未入力時のメッセージ表示未
