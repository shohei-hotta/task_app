class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :login_required

  def index
    index_tasks = Task.select_index 
    if params[:sort_expired_up]
      tasks = index_tasks.sort_deadline_up
    elsif params[:sort_expired_down]
      tasks = index_tasks.sort_deadline_down
    elsif params[:sort_priority_up]
      tasks = index_tasks.sort_priority_up
    elsif params[:sort_priority_down]
      tasks = index_tasks.sort_priority_down
    elsif params[:search].nil?
      tasks = index_tasks.recent
    elsif params[:search][:name].blank? && params[:search][:status].blank?
      tasks = index_tasks.recent
    else
      if params[:search][:name].present? && params[:search][:status].present?
        tasks = index_tasks.search_name(params[:search][:name]).search_status(params[:search][:status])
      elsif params[:search][:name].present?
        tasks = index_tasks.search_name(params[:search][:name])
      elsif params[:search][:status].present?
        tasks = index_tasks.search_status(params[:search][:status])
      end
    end
    @tasks = tasks.page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
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

  def login_required
    redirect_to new_session_url, danger: "#{t("view.flash.require_login_alert")}" unless logged_in?
  end
end
