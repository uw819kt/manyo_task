class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  # ログイン機能
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:notice] = 'ログインしました'
      # ログイン成功した場合
      if user.admin? # 管理者か確認
        redirect_to tasks_path # 管理者画面(true)
      else
        redirect_to tasks_path(user.id) # 利用者画面(false)
      end
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
      # ログイン失敗した場合
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

end
