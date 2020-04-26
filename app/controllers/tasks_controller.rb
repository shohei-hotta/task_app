class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: :DESC)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_url(@task.id), notice: "「#{@task.name}」#{t("view.flash.create_message")}"
    else
      flash.now[:alert] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "「#{@task.name}」#{t("view.flash.edit_message")}"
    else
      flash.now[:alert] = "#{t("view.flash.edit_alert")}"
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "「#{@task.name}」#{t("view.flash.destroy_message")}"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
