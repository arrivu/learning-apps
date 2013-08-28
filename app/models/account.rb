class Account < ActiveRecord::Base
  attr_accessible :active, :name, :no_of_courses, :no_of_users, :organization,:support_script, :google_analytics_script
  cattr_accessor :current
  RESERVED_SUBDOMAINS = %w(
  admin api assets blog calendar  developer developers docs files ftp git lab mail manage pages sites ssl staging status support www
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
  has_one  :account_setting
  has_one  :terms_and_condition
  def self.default
    Account.first
  end

  def self.load_account
    unless current_subdomain.nil?
      @domain_root_account= Account.find_by_name current_subdomain
      if (@domain_root_account == nil)
        redirect_to request.url.sub(current_subdomain, Account.default.name)
      else
        @account_id= @domain_root_account.id
      end
    else
      @domain_root_account=Account.default
    end
  end

  def add_user(user, membership_type = nil)
    return nil unless user && user.is_a?(User)
    membership_type ||= 'student'
    au = self.account_users.find_by_user_id_and_membership_type(user.id, membership_type)
    au ||= self.account_users.create(:user_id => user.id, :membership_type => membership_type)
  end

end
