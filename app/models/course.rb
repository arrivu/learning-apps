
# == Schema Information
#
# Table name: courses
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  author       :string(255)
#  image        :string(255)
#  desc         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  is_published  :integer          default(0)
#  release_month :string(255)      default("December")
#

class Course < ActiveRecord::Base
  self.per_page = 6
  acts_as_commentable
  attr_accessible :content, :name, :tag_list ,:tag_tokens
  attr_accessible :lms_id,:author, :desc, :image, :title, :topic_id, :user_id, :is_published,
  :release_month, :is_coming_soon,:is_popular,:filename,:content_type,:data, :short_desc,:teaching_staff_ids,
  :concluded_at,:is_concluded,:concluded_review,:start_date,:end_date,:account_id,:is_global,
  :course_image,:course_background_image
  has_attached_file :course_image, :styles => { :medium => "270x150#", :thumb => "80x80#",:small=> "40x40#" },
                    :default_url => "/images/:style/course_image.png"
  has_attached_file :course_background_image, :styles => { :medium => "670x250#", :thumb => "270x150#" },
                    :default_url => "/images/:style/course_background_image.png"
  cattr_accessor :tag_tokens
  scope :teachers, joins(:teaching_staff_courses).where('teaching_staff_courses.teaching_staff_type = ?', "teacher")
  scope :teacher_assistants, joins(:teaching_staff_courses).where('teaching_staff_courses.teaching_staff_type = ?', "teacher_assitant")
  scope :enrolled_students, joins(:student_courses).where('student_courses.status = ?', "enroll") 
  scope :completed_students, joins(:student_courses).where('student_courses.status = ?', "completed") 
  scope :shortlisted_students, joins(:student_courses).where('student_courses.status = ?', "shortlisted") 
  scope :following_students, joins(:student_courses).where('student_courses.status = ?', "follow")
  scope :student_enroll
  scope :student_complete
  scope :student_shortlist
  scope :student_follow
  scope :teacher_course
  scope :teacher_assistant_course
  belongs_to :topic
  has_many :student_courses, :dependent =>:destroy
  has_many :students, :through => :student_courses
  has_many :teaching_staff_courses, :dependent =>:destroy
  has_many :teaching_staffs, :through => :teaching_staff_courses
  has_one  :rating_cache
  belongs_to :user
  belongs_to :account
  belongs_to :category
  letsrate_rateable "rate"
  has_one :course_pricing
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :sections
  has_many :course_modules
  attr_reader :tag_tokens
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  #def tag_tokens=(tokens)
  #  self.tag_ids = Tag.ids_from_tokens(tokens)
  #end
  validates :title, presence: true, length: { maximum: 100 }
  has_many :course_previews
  has_many :invoices
  validates :desc, presence: true, length: { maximum: 1000 }
  validates  :short_desc, presence: true, length:{maximum: 100}

  default_scope order: 'courses.created_at ASC'
  def self.course_price(course)
    course.course_pricings.each do |course_price|
      if course_price.start_date <= Date.today && course_price.end_date >= Date.today
        @price = course_price.price
      end
    end
    return @price
  end
  def self.tax_calculation(course, price)
    tax_rate= ApplicationController.helpers.tax_rate_for_today.factor
    tax = price.to_f * (tax_rate.to_f/100.to_f)
    return tax.round(2)
  end
  def student_enrolled
    load_student("enroll")  
  end
  def student_completed
    load_student("completed")  
  end 

  def student_shortlisted
    load_student("shortlisted")
  end 

  def student_follow
    load_student("follow")
  end 

  def load_student( status)
    student_ids = []
    self.student_courses.where(:status => status).each do |course_status|
      student_ids << course_status.student_id
    end
    Student.find(courses_ids)      
  end


  def staff_image
    #named_scope :omni_image_url, lambda {|c| {:joins=>([:courses,:teaching_staffs,:users]):conditions=>['baz_cat=',c]}}
  end

  def teacher_course
   self.teaching_staff_courses.where(:teaching_staff_type => "teacher")
  end

  def teacher_assistant_course
    self.teaching_staff_courses.where(:teaching_staff_type => "teacher_assitant")
  end

  def attachment=(incoming_file)
    self.image = incoming_file.original_filename
    self.content_type = incoming_file.content_type
    self.data = incoming_file.read
  end

  def background=(incoming_file)
    self.background_image_type = incoming_file.content_type
    self.background_image = incoming_file.read
  end


  def image=(new_filename)
    write_attribute("image", sanitize_filename(new_filename))
  end
   #def self.authorimage(courseid)
  #find_by_sql("select u.image_blob,u.name from teaching_staff_courses t left join user u on t.teaching_staff_id=u.id left join course c on c.id=t.course_id
   #where c.id=#{courseid}")
  #end
  

  def course_price_inbetween_date
   self.course_pricings.find(:all, :conditions => "#{Date.today} >= start_date or #{Date.today} <= end_date")
  end

  #-------------------------------Private Methods-------------------
  private
  def sanitize_filename(filename)
    #get only the filename, not the whole path (from IE)
    just_filename = File.basename(filename)
    #replace all non-alphanumeric, underscore or periods with underscores
    just_filename.gsub(/[^\w\.\-]/, '_')
  end

  HUMANIZED_ATTRIBUTES = {
    :short_desc => "Short Description",
    :desc => "Description"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
 
end
