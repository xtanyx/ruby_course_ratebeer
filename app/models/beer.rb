class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validate :brewery_does_not_exist_in_database

  validates :name, presence: true
  validates :style, presence: true
  validates :brewery, presence: true

  def to_s
    "#{name} from brewery #{brewery.name}"
  end

  def brewery_does_not_exist_in_database
    return if brewery.valid?

    errors.add :brewery, message: "no such brewery exists"
  end
end
