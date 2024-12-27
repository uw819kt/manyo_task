class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
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
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "タスクを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end
  
  
  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = Task.new(task_params)
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
      params.require(:task).permit(:title, :content)
    end
end
