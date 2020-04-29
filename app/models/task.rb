class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 200 }

  scope :search_name, ->(params) { where("name LIKE ?", "%#{params}%") }
  scope :search_status, ->(params) { where(status: params) }
  scope :recent, -> { order(created_at: :DESC) }
  scope :sort_deadline, -> { order(:deadline) }
end
