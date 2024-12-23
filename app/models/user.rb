class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validate :password_suitable

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: {minimum: 4}
  
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_suitable
    chars = ('A'...'Z').to_a
    digits = ("0"..."9").to_a
    if password.present? &&
      (password.chars.filter {|ch| chars.include?(ch)}.empty? || password.chars.filter {|ch| digits.include?(ch)}.empty?)
      errors.add :password, "must include one uppercase letter and one digit"
    end
  end
end
