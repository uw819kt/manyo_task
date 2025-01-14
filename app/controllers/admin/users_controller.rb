class Admin::UsersController < ApplicationController
  before_action :admin_required
  # 管理者か判定が行われ、trueでないとコントローラにアクセス不可
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :redirect_logged_in, only: [:new, :create]
  # 管理者のログインではなくユーザ情報の変更なのでスキップしてよい(継承されているので呼び出される)

  def index
    @users = User.all
  end

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(user_params)
    if @admin.save
      flash[:notice] = 'ユーザを登録しました'
      redirect_to admin_users_path
      # 成功した場合
    else
      render :new
      # 失敗した場合   
    end  
  end

  def show
    @admin = User.find(params[:id])
  end

  def edit
    @admin = current_user
    #edit.htmlと依存関係が発生、htmlファイルはローカル変数が望ましい
  end

  def update
    @admin = User.find(params[:id]) #データ取得
    if @admin.update(user_params)
      flash[:notice] = 'ユーザを更新しました'
      redirect_to admin_users #ユーザの詳細ページ(show)へ
    else
      flash[:error] = 'ユーザを更新できませんでした'
      render :edit
      #失敗の処理はrenderでないとバリデーション×、編集画面出力、
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to new_session_path
    #ビューファイルのリンクはルーティングヘルパーを使う、手動×
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def admin_required
    unless current_user&.admin?
      flash[:alert] = "管理者専用のページです"
      redirect_to tasks_path
    end
  end

end
