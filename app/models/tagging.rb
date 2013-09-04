class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :course
  attr_accessible :tag_id, :course_id
end
