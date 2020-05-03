class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :password_confirmation, presence: true

  before_validation { email.downcase! }
  before_update :not_update_last_admin
  before_destroy :not_destroy_last_admin

  private

  def not_update_last_admin
    throw(:abort) if User.where(admin: true).count == 1
  end

  def not_destroy_last_admin
    throw(:abort) if User.where(admin: true).count == 1
  end
end
