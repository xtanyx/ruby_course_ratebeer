module RatingAverage
  extend ActiveSupport::Concern

  include Enumerable

  def average_rating
    scores = ratings.map(&:score)
    return 0 if scores.empty?
    
    sum = scores.sum

    (sum.to_f / ratings.count).truncate(2)
    # return Rating.where(beer_id: self.id).average(:score)
  end
end
