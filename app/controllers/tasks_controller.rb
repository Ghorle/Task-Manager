class TasksController < ApplicationController
  before_action :authenticate_request
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @current_user.tasks.page(params[:page]).per(10)
    render json: tasks, each_serializer: TaskSerializer
  end

  def show
    render json: @task 
  end

  def create
    task = @current_user.tasks.build(task_params)
    if task.save
      render json: { message: "Task created successfully.", data: task }, status: :ok
    else
      render json: { message: task.errors.full_messages }, status: :unprocessable_entity
    end
  end 

  def update
    if @task.update(task_params)
      @task.reload
      render json: { message: "Task updated successfully.", data: @task }, status: :ok
    else
      render json: { message: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: { message: "Task deleted successfully." }, status: :ok
    else
      render json: { message: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def set_task
    @task = @current_user.tasks.find_by(id: params[:id])
    render json: { message: 'Task not found' }, status: :not_found unless @task
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
