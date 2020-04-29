class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 200 }

  scope :search_name, -> { where("name LIKE ?", "%#{params[:search][:name]}%") }
  scope :search_status, -> { where(status: params[:search][:status]) }
  scope :search_name_and_status, -> { search_name.search_status }
  scope :recent, -> { order(created_at: :DESC) }
  scope :sort_deadline, -> { order(:deadline) }
end
