class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if params[:sort_expired_up]
      @tasks = Task.select_index.sort_deadline_up.page(params[:page])
    elsif params[:sort_expired_down]
      @tasks = Task.select_index.sort_deadline_down.page(params[:page])
    elsif params[:sort_priority_up]
      @tasks = Task.select_index.sort_priority_up.page(params[:page])
    elsif params[:sort_priority_down]
      @tasks = Task.select_index.sort_priority_down.page(params[:page])
    elsif params[:search].nil?
      @tasks = Task.select_index.recent.page(params[:page])
    elsif params[:search][:name].blank? && params[:search][:status].blank?
      @tasks = Task.select_index.recent.page(params[:page])
    else
      if params[:search][:name].present? && params[:search][:status].present?
        @tasks = Task.select_index.search_name(params[:search][:name]).search_status(params[:search][:status]).page(params[:page])
      elsif params[:search][:name].present?
        @tasks = Task.select_index.search_name(params[:search][:name]).page(params[:page])
      elsif params[:search][:status].present?
        @tasks = Task.select_index.search_status(params[:search][:status]).page(params[:page])
      end
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
      redirect_to task_url(@task.id), success: "「#{@task.name}」#{t("view.flash.create_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, success: "「#{@task.name}」#{t("view.flash.edit_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.edit_alert")}"
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, success: "「#{@task.name}」#{t("view.flash.destroy_message")}"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
