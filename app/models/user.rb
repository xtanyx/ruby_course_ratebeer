class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validate :password_suitable

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_suitable
    chars = ('A'...'Z').to_a
    digits = ("0"..."9").to_a
    if password.present? &&
       (password.chars.none? { |ch| chars.include?(ch) } || password.chars.none? { |ch| digits.include?(ch) })
      errors.add :password, "must include one uppercase letter and one digit"
    end
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    max_rated_style.first
  end

  def ratings_by_style
    ratings.group_by { |rating| rating.beer.style }.map { |g| g }
  end

  def average(rats)
    scores = rats.map(&:score)
    return 0 if scores.empty?

    sum = scores.sum

    (sum.to_f / rats.count).truncate(2)
    # return Rating.where(beer_id: self.id).average(:score)
  end

  def averaged_styles
    r_by_style = ratings_by_style
    r_by_style.map { |g| [g[0], average(g[1])] }
  end

  def max_rated_style
    averaged_styles.max_by { |g| g[1] }
  end

  def favorite_brewery
    return nil if ratings.empty?

    max_rated_brewery.first
  end

  def ratings_by_brewery
    ratings.group_by { |rating| rating.beer.brewery }.map { |g| g }
  end

  def averaged_breweries
    r_by_brewery = ratings_by_brewery
    r_by_brewery.map { |g| [g[0], average(g[1])] }
  end

  def max_rated_brewery
    averaged_breweries.max_by { |g| g[1] }
  end
end
