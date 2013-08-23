class Account < ActiveRecord::Base
  attr_accessible :active, :name, :no_of_courses, :no_of_users, :organization,:support_script, :google_analytics_script
  RESERVED_SUBDOMAINS = %w(
  admin api assets blog calendar demo developer developers docs files ftp git lab mail manage pages sites ssl staging status support www
)
  validates_exclusion_of :name, :in => RESERVED_SUBDOMAINS,
                         :message => "Subdomain/Account Name %{value} is reserved."
  has_many :account_users , :dependent => :destroy
  has_many :partners , :dependent => :destroy
  has_many :courses, :dependent => :destroy
  has_many :course_previews, :dependent => :destroy
  has_many :topics,:dependent =>:destroy
  has_many :tax_rates,:dependent =>:destroy
  has_many :teaching_staffs, :dependent =>:destroy
  has_many :testimonials, :dependent => :destroy
  has_many :teaching_staff_courses, :dependent => :destroy
  has_one  :account_theme
  def self.default
    Account.first
  end

  def add_user(user, membership_type = nil)
    return nil unless user && user.is_a?(User)
    membership_type ||= 'student'
    au = self.account_users.find_by_user_id_and_membership_type(user.id, membership_type)
    au ||= self.account_users.create(:user_id => user.id, :membership_type => membership_type)
  end

end
