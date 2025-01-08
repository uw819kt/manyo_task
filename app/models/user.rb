class User < ApplicationRecord
  has_many :tasks
  
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
end
