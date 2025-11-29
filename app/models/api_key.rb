require 'securerandom'

class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true
  validates :user, presence: true

  before_validation :generate_key, on: :create

  scope :active, -> { where(revoked_at: nil) }

  delegate :plan, :rate_limit, :rate_limit_period, to: :user

  def active?
    revoked_at.nil?
  end

  def revoke!
    update(revoked_at: Time.now)
  end

  private

  def generate_key
    self.key ||= "sk_#{SecureRandom.hex(32)}"
  end
end
