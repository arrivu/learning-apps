
class TeachingStaff  < ActiveRecord::Base
  scope :active, -> { where("is_active IS true") }
  attr_accessible :description, :name, :qualification,:user_attributes, :user_id, :linkedin_profile_url,:account_id ,:is_active,:firstname,:lastname,:headline,:biography,:address,:city,:pincode,:phonenumber
  scope :teachers, joins(:teaching_staff_courses).where('teaching_staff_courses.teaching_staff_type = ?', "teacher")
  scope :teacher_assistants, joins(:teaching_staff_courses).where('teaching_staff_courses.teaching_staff_type = ?', "teacher_assitant")
  scope :teacher
  scope :teacher_assistant
  has_many :teaching_staff_courses
  has_many :courses, :through => :teaching_staff_courses 
  belongs_to :user, dependent: :destroy
  belongs_to :account
  accepts_nested_attributes_for :user
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 300}
  validates :qualification, presence: true

  def teacher
     self.teaching_staff_courses.where(:teaching_staff_type => "teacher")
  end

  def teacher_assistant
     self.teaching_staff_courses.where(:teaching_staff_type => "teacher_assitant")
  end

  def courses
    self.teaching_staff_courses.where(:teaching_staff_id => self.id,:account_id => @account_id)
  end

end

