class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
  
  attr_accessible :rate, :dimension
  
def rate(stars, user, dimension=nil)
    dimension = nil if dimension.blank?

    if can_rate? user, dimension
      rates(dimension).create! do |r|
        r.stars = stars
        r.rater = user
      end
      update_rate_average(stars, dimension)
    else
      raise "User has already rated."
    end
  end
end
