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
  attr_accessible :name, :desc,:id,:color,:account_id,:parent_topic_id,:root_topic_id
  has_ancestry
  has_many :courses,  :dependent => :delete_all
  belongs_to :account
  has_many :sub_topics,:class_name => "Topic" ,:foreign_key =>  'parent_topic_id' ,:dependent => :destroy
  has_many :all_topics, :class_name => 'Topic', :foreign_key =>  'account_id'
  validates :name, presence: true, length: { maximum: 100 }

end
