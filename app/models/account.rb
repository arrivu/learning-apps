class Account < ActiveRecord::Base
  attr_accessible :active, :name, :no_of_courses, :no_of_users, :organization,:support_script, :google_analytics_script, :settings,:terms_of_service
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
  has_one  :account_theme
  has_one  :terms_and_condition
  has_many :sections
  has_many :course_modules
  serialize :settings, Hash
  cattr_accessor :account_settings_options
  self.account_settings_options = {}
  has_many :tags
  has_many  :teaching_staff_courses
  has_many :course_pricings
  has_many :coupons
  has_many :student_courses
  has_many :students
  validates :name, presence: true, uniqueness: true
  validates :organization, presence: true
  validates_acceptance_of :terms_of_service
  def self.default
    Account.find(1)
  end

  def add_user(user, membership_type = nil)
    return nil unless user && user.is_a?(User)
    membership_type ||= 'student'
    au = self.account_users.find_by_user_id_and_membership_type(user.id, membership_type)
    au ||= self.account_users.create(:user_id => user.id, :membership_type => membership_type)
  end

  def self.add_setting(setting, opts=nil)
    self.account_settings_options[setting.to_sym] = opts || {}
    if (opts && opts[:boolean] && opts.has_key?(:default))
      if opts[:default]
        self.class_eval "def #{setting}?; settings[:#{setting}] != false; end"
      else
        self.class_eval "def #{setting}?; !!settings[:#{setting}]; end"
      end
    end
  end


add_setting :cas_enable, :root_only => false,:boolean => true, :default => true
add_setting :cas_expiry_time, :root_only => false, :default => 28800
add_setting :cas_url, :root_only => false
add_setting :cas_login_path, :root_only => false, :default => true
add_setting :cas_logout_path, :root_only => false, :default => true
add_setting :lms_enable, :root_only => false,:boolean => true, :default => false
add_setting :lms_account_id, :root_only => false, :default => 1
add_setting :lms_oauth_token, :root_only => false
add_setting :lms_root_url, :root_only => false
add_setting :lms_course_url_path, :root_only => false, :default => true
add_setting :lms_api_root_url, :root_only => false
add_setting :lms_logout_path, :root_only => false, :default => true
add_setting :mailserver_address, :root_only => false
add_setting :mailserver_port, :root_only => false, :default => 587
add_setting :mailserver_domain, :root_only => false
add_setting :mailserver_user_name, :root_only => false
add_setting :mailserver_password, :root_only => false
add_setting :admin_mail_to, :root_only => false
add_setting :mailserver_signature ,:root_only => false
add_setting :payment_gateway_enable, :root_only => false,:boolean => true
add_setting :payment_gateway_merchant_id, :root_only => false
add_setting :payment_gateway_work_key, :root_only => false
add_setting :payment_gateway_ccavenue_account, :root_only => false
add_setting :invoices_notes, :root_only => false, :default => true
add_setting :exception_notifer_email_prefix, :root_only => false
add_setting :exception_notifer_sender_address, :root_only => false
add_setting :exception_notifer_exception_recipients, :root_only => false
add_setting :omniauth_facebook_key, :root_only => false
add_setting :omniauth_facebook_secret, :root_only => false
add_setting :omniauth_linkedin_key, :root_only => false
add_setting :omniauth_linkedin_secret, :root_only => false
add_setting :omniauth_google_oauth2_key, :root_only => false
add_setting :omniauth_google_oauth2_secret, :root_only => false
add_setting :knowledge_partners_enable, :root_only => false, :boolean => true
add_setting :media_partners_enable, :root_only => false, :boolean => true
add_setting :slide_show_enable, :root_only => false, :boolean => true
add_setting :popular_speak_enable, :root_only => false, :boolean => true
add_setting :testimonial_enable, :root_only => false, :boolean => true
add_setting :popular_course_enable, :root_only => false,:boolean => true, :default => true
add_setting :account_statistics_enable, :root_only => false,:boolean =>true, :default => true
add_setting :signup_teacher_enable, :root_only => false,:boolean =>true, :default => true
add_setting :domain_url,:root_only => false
add_setting :open_student_registration, :root_only => false,:boolean =>true, :default => true

  def settings=(hash)
    if hash.is_a?(Hash)
      hash.each do |key, val|
        if account_settings_options && account_settings_options[key.to_sym]
          opts = account_settings_options[key.to_sym]
          if (opts[:root_only] && !self.root_account?) || (opts[:condition] && !self.send("#{opts[:condition]}?".to_sym))
            settings.delete key.to_sym
          elsif opts[:boolean]
            settings[key.to_sym] = (val == true || val == 'true' || val == '1' || val == 'on')
          elsif opts[:hash]
            new_hash = {}
            if val.is_a?(Hash)
              val.each do |inner_key, inner_val|
                if opts[:values].include?(inner_key.to_sym)
                  new_hash[inner_key.to_sym] = inner_val.to_s
                end
              end
            end
            settings[key.to_sym] = new_hash.empty? ? nil : new_hash
          else
            settings[key.to_sym] = val.to_s
          end
        end
      end
    end
    settings
  end

  def settings
    result = self.read_attribute(:settings)
    return result if result
    return write_attribute(:settings, {}) unless frozen?
    {}.freeze
  end
end
