# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  desc       :string(255)
#

class Topic < ActiveRecord::Base
  attr_accessible :name, :desc,:id,:color,:account_id,:parent_id,:root_id
  #has_many :relationships
  #has_one :courses, through: :relationships
  has_many :courses,  :dependent => :delete_all
  belongs_to :account
  validates :name, presence: true, length: { maximum: 100 }

end
