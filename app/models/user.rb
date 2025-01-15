class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email,uniqueness: { message: "はすでに使用されています" }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6,
             too_short: "は6文字以上で入力してください"          
             }
  validates :password, presence: true
  validates :password, confirmation: {message: "とパスワードが一致しません"}
  validates :admin, inclusion: { in: [true, false] }
  # inclusionは与えられた集合に属性の値が含まれているか否かを検証

  before_update :admin_update_confirmation, if: :admin_changed? 
  # if: :条件→特定の条件を満たす場合のみコールバックを実行するための条件を指定
  # _changed→属性が変更した時にtrueを返すRailsのヘルパーメソッド
  before_destroy :admin_destoroy_confirmation, if: :admin?


  def admin? # 管理者かどうかを確認する
    admin
  end
  private

  def admin_update_confirmation # 更新前確認
    if self.admin == false && User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw :abort # 更新処理中止
    end
  end

  def admin_destoroy_confirmation # 削除前確認
    if  User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため削除できません")
      throw :abort # 削除処理中止
    end
  end
end
# コールバックのbefore_updateを使って人数を調べる、処理止める、メッセージ表示をする
