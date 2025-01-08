class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(admin: false)) # 登録フォーム入力値、現在admin: false
    if @user.save
      log_in(@user)
      flash[:notice] = 'アカウントを登録しました'
      redirect_to user_path(@user.id)
      # 成功した場合
    else
      render :new
      # 失敗した場合   
    end  
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
    #edit.htmlと依存関係が発生、htmlファイルはローカル変数が望ましい
  end

  def update
    @user = current_user #データ取得
    if @user.update(user_params)
      flash[:notice] = 'アカウントを更新しました'
      redirect_to user_path(@user) #ユーザの詳細ページ(show)へ
    else
      flash[:error] = 'アカウントを更新できませんでした'
      render :edit
      #失敗の処理はrenderでないとバリデーション×、編集画面出力、
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
  # パラメータのidを使ってデータベースからユーザを取り出し、current_user?メソッドの引数に渡す  
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end
