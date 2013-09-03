class Tag < ActiveRecord::Base
  attr_accessible :account_id, :name
  validates :name,:account_id, presence: true
  validates_uniqueness_of :name, :scope => :account_id
  belongs_to :account
  has_many :taggings
  has_many :courses, through: :taggings

  def self.tokens(query)
    tags = where("name like ?", "%#{query}%")
    if tags.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      tags
    end
  end

end
