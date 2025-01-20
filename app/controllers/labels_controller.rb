class LabelsController < ApplicationController
  def index
    @labels = Label.all
  end

  def new
    @labels = Label.new
  end

  def create
    @labels = Label.new(label_params)
    @labels.user_id = current_user.id
    if @labels.save
      flash[:success] = 'ラベルを登録しました'
      redirect_to labels_path
      # 成功した場合
    else
      render :new
      # 失敗した場合   
    end
  end

  def show
  end

  def edit
    @labels = Label.find(params[:id])
  end

  def update
    @labels = Label.find(params[:id]) #データ取得
    if @labels.update(label_params)
      flash[:success] = 'ラベルを更新しました'
      redirect_to labels_path #ユーザの詳細ページ(show)へ
    else
      flash[:alert] = @labels.errors.full_messages.to_sentence
      render :edit
      #失敗の処理はrenderでないとバリデーション×、編集画面出力、
    end
  end

  def destroy
    @labels = Label.find(params[:id])
    if @labels.destroy
      flash[:success] = 'ラベルを削除しました'
    else
      flash[:alert] = @labels.errors.full_messages.to_sentence
      # モデルのエラーメッセージをフラッシュに設定
    end
    redirect_to labels_path
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end 
end
