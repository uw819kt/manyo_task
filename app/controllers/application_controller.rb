class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  # before_action :admin_required
  #アクション実行前にlogin_requiredが呼ばれる
  before_action :redirect_logged_in, only: [:new, :create]
  

  private

  def login_required #ログインしないとアクセス不可
    unless current_user
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
      #current_user=nillでログイン画面に遷移
    end
  end

  def redirect_logged_in # ログイン中ログイン画面アクセスでリダイレクト
    if logged_in?
      flash[:alert] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end  
end
