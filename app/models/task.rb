class Task < ApplicationRecord
  # belongs_to :user step3終わるまで

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: {低: 0, 中: 1, 高: 2} # 英語で入力
  enum status: {未着手: 0, 着手中: 1, 完了: 2}
  # enum カラム対応名: [:キーワード, :キーワード, ...]
  def self.search_status(status)
    where(status: statuses[status])  # "着手中" -> 1 に変換される
  end

  scope :sort_by_deadline, -> { order(deadline_on: :asc) } # 終了期限でソート
  scope :sort_by_priority, -> { order(priority: :desc, created_at: :desc) } # 優先度でソート
  scope :sort_by_created_at, -> { order(created_at: :desc) } # 作成日でソート(デフォルト)

  scope :search_title, ->(title) { where('title LIKE ?', "%#{title}%") } # タイトルで検索
  scope :search_status, ->(status) { where(status: status) } # ステータスで検索
  scope :search_title_and_status, ->(title, status) { search_title(title).search_status(status) } # タイトルとステータスで検索
  #  scope :スコープの名前, -> (引数){ 条件式 } 
end


