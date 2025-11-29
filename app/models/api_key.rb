require 'securerandom'

class ApiKey < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :name, presence: true

  before_validation :generate_key, on: :create

  scope :active, -> { where(revoked_at: nil) }

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
