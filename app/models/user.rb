class User < ActiveRecord::Base
  PLANS = {
    'free' => { limit: 100, period: 1.hour },
    'basic' => { limit: 1000, period: 1.hour },
    'pro' => { limit: 10000, period: 1.hour }
  }.freeze

  has_many :api_keys, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :plan, presence: true, inclusion: { in: PLANS.keys }

  before_validation :set_default_plan, on: :create

  def rate_limit
    PLANS[plan][:limit]
  end

  def rate_limit_period
    PLANS[plan][:period]
  end

  private

  def set_default_plan
    self.plan ||= 'free'
  end
end
