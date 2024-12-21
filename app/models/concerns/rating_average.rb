module RatingAverage
  extend ActiveSupport::Concern
  
  include Enumerable

  def average_rating
    scores = self.ratings.map {|rating| rating.score}
    sum = scores.sum

    return (sum.to_f/ratings.count)
    # return Rating.where(beer_id: self.id).average(:score)
  end
end