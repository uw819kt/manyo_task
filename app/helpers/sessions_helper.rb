module SessionsHelper
# 毎回ログイン中のユーザ情報を取得するコードを書かなくて済む

  def current_user 
    # 現在ログイン中のユーザが代入
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in? # ユーザがログイン中かどうかを判断する
    current_user.present?
  end
  
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    # 引数で送られてきたユーザとログインしているユーザとを比較
    user == current_user
  end
end
