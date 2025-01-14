class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  skip_before_action :redirect_logged_in, only: [:new, :create]
  before_action :check_task_owner, only: [:show, :edit]
  
  # GET /tasks or /tasks.json
  def index
    @tasks = current_user.tasks
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
        @tasks = Task.search_title_and_status(params[:search][:title], params[:search][:status]).page(params[:page]).per(10)
      elsif params[:search][:title].present? 
      # パラメータにタイトルのみがあった場合
        @tasks = Task.search_title(params[:search][:title]).page(params[:page]).per(10)
      elsif params[:search][:status].present?
      # パラメータにステータスのみがあった場合
        status_value = Task.statuses[params[:search][:status]]
        @tasks = Task.search_status(status_value).page(params[:page]).per(10)
      end
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end
  
  
  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = "タスクを更新しました"
      redirect_to task_path(@task)
    else
      flash[:notice] = "Title can't be blank."
      render :edit
    end
  end
  

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスクを削除しました" }
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def task_search_params
    params.fetch(:search, {}).permit(:status, :title)
    # params[:search]が空の時{}を返し、params[:search]が空でない場合、params[:search]を返す
  end
    
  def check_task_owner
    @task = Task.find(params[:id])
    if @task.user != current_user
      flash[:alert] = "管理者以外アクセスできません"
      redirect_to tasks_path
    end
  end  
end
