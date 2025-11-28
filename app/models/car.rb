class Car < ActiveRecord::Base
  validates :model, presence: true
  validates :brand, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :color, presence: true

  def to_hash
    {
      id: id,
      model: model,
      brand: brand,
      year: year,
      color: color
    }
  end
end
