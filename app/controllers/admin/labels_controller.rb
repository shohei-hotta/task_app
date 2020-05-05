class Admin::LabelsController < ApplicationController
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

  def edit
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end
end
