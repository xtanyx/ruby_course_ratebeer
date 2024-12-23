class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true

  def to_s
    "#{name} from brewery #{brewery.name}"
  end
end
