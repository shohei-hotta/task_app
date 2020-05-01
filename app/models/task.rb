class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 200 }
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: { 低: 0, 中: 1, 高: 2 }

  scope :select_index, -> { select(:id, :name, :deadline, :status, :priority, :created_at) }
  scope :search_name, ->(params) { where("name LIKE ?", "%#{params}%") }
  scope :search_status, ->(params) { where(status: params) }
  scope :recent, -> { order(created_at: :DESC) }
  scope :sort_deadline_up, -> { order(:deadline) }
  scope :sort_deadline_down, -> { order(deadline: :DESC) }
  scope :sort_priority_up, -> { order(:priority) }
  scope :sort_priority_down, -> { order(priority: :DESC) }
end
