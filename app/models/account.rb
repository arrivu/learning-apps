class Account < ActiveRecord::Base
  attr_accessible :active, :name, :no_of_courses, :no_of_users, :organization,:support_script, :google_analytics_script, :settings
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
  serialize :settings, Hash
  cattr_accessor :account_settings_options
  self.account_settings_options = {}

  def self.default
    Account.first
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
  add_setting :global_includes, :root_only => true, :boolean => true, :default => false
  add_setting :knowledge_partners, :root_only => false, :boolean => true, :default => false
  add_setting :media_partners, :root_only => false, :boolean => true, :default => false
  add_setting :slide_show, :root_only => false, :boolean => true, :default => false
  add_setting :popular_speak, :root_only => true, :boolean => true, :default => false
  add_setting :testimonial, :root_only => true, :boolean => true, :default => false


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
    result = self.read_attribute(:settingsnew)
    return result if result
    return write_attribute(:settingsnew, {}) unless frozen?
    {}.freeze
  end



end
