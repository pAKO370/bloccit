class Rating < ActiveRecord::Base

  enum severity: [ :PG, :PG13, :R]

  has_many :topics

  has_many :posts

  def self.update_rating(rating_string)
    return Rating.none if rating_string.blank?

    rating = rating_string.severity

  end

end
