class Style < ApplicationRecord
  has_many :beers, dependent: :destroy

  def to_s
    name
  end
end
