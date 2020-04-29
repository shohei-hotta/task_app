class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if params[:sort_expired]
      @tasks = Task.select_index.sort_deadline
    elsif params[:search]
      if params[:search][:name].present? && params[:search][:status].present?
        @tasks = Task.select_index.search_name(params[:search][:name]).search_status(params[:search][:status])
      elsif params[:search][:name].present?
        @tasks = Task.select_index.search_name(params[:search][:name])
      elsif params[:search][:status].present?
        @tasks = Task.select_index.search_status(params[:search][:status])
      end
    else
      @tasks = Task.select_index.recent
    end
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
    params.require(:task).permit(:name, :description, :deadline, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
