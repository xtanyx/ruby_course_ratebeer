class Rating < ApplicationRecord
  belongs_to :beer

  def to_s
    "writing rating"
  end
end
