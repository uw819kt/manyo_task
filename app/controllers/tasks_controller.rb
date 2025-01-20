class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :check_task_owner, only: [:show, :edit, :update, :destroy]
  
  # GET /tasks or /tasks.json
  def index
    @tasks = current_user.tasks.includes(:labels, :user) # N+1問題対策で1回で2つ読み込み
    @label = Label.find(params[:label_id]) if params[:label_id].present?
    # パラメータからラベルIDを取得、ラベルをセット
    sort_deadline = params[:sort_deadline_on]
    sort_priority = params[:sort_priority]

    if sort_deadline == "true"
      @tasks = @tasks.sort_by_deadline.page(params[:page]).per(10)
      # 終了期限ソート(10件ずつ表示)
    elsif sort_priority == "true"
      @tasks = @tasks.sort_by_priority.page(params[:page]).per(10)
      # 優先度ソート(10件ずつ表示)
    else
      @tasks = @tasks.sort_by_created_at.page(params[:page]).per(10)
      # ノーマル(10件ずつ表示)
    end

    if params[:search].present? # searchパラメータがあるか?
      if params[:search][:title].present? && params[:search][:status].present? 
      # パラメータにタイトルとステータスの両方があった場合
        @tasks = @tasks.search_title_and_status(params[:search][:title], params[:search][:status]).page(params[:page]).per(10)
      elsif params[:search][:title].present? 
      # パラメータにタイトルのみがあった場合
        @tasks = @tasks.search_title(params[:search][:title]).page(params[:page]).per(10)
      elsif params[:search][:status].present?
      # パラメータにステータスのみがあった場合
        status_value = @tasks.statuses[params[:search][:status]]
        @tasks = @tasks.search_status(status_value).page(params[:page]).per(10)
      elsif params[:search][:labels_id].present?
      # パラメータがラベルだった場合
        label_id = params[:search][:labels_id] # ラベルに関連するタスクを絞り込む
        @tasks = @tasks.joins(:labels).where(labels: { id: label_id }).page(params[:page]).per(10)
        # tasksとlabelsテーブルをJOIN、指定されたlabel_idを持つタスクだけ取得
      end
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @labels = current_user.labels
  end

  # GET /tasks/1/edit
  def edit
    @labels = Label.all # 全てのラベルを取得
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end
  
  
  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if @task.update(task_params)
      flash[:success] = "タスクを更新しました"
      redirect_to task_path(@task)
    else
      @labels = Label.all
      flash[:danger] = "入力してください"
      render :edit
    end
  end
  

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, success: "タスクを削除しました" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end

  def task_search_params #params[:search]を処理、検索条件として利用できるパラメータを返す
    params.fetch(:search, {}).permit(:status, :title, :label)
    # params.fetch(:search, {})→paramsハッシュの中から:searchキーの値を取得
    # params[:search]が空の時{}を返し、params[:search]が空でない場合、params[:search]を返す
  end
    
  def check_task_owner #他人のタスクにアクセスできないようにする
    @task = Task.find(params[:id])
    if @task.user != current_user
      flash[:danger] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end
end
