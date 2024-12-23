class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :year_is_less_than_or_equal_to_current_year
  validates :name, presence: true
  validates :year, numericality: {
    greater_than_or_equal_to: 1040,
    only_integer: true
  }

  def year_is_less_than_or_equal_to_current_year
    return unless year > Date.today.year

    errors.add(:year, "can't be greater than current year")
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  def to_s
    name.to_s
  end
end
