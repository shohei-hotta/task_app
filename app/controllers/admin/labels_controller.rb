class Admin::LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = Label.select(:id, :name, :created_at)
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to admin_labels_url, success: "「#{@label.name}」#{t("view.flash.create_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.create_alert")}"
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to admin_labels_url, success: "「#{@label.name}」#{t("view.flash.edit_message")}"
    else
      flash.now[:danger] = "#{t("view.flash.edit_alert")}"
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to admin_labels_url, success: "「#{@label.name}」#{t("view.flash.destroy_message")}"
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end
end
