# == Schema Information
#
# Table name: users
#

#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
# 
#  phone                  :string(255)
#  user_type              :string(255)
#  sub_plan               :string(255)
#  user_desc              :string(255)
#  name                   :string(255)
#  username               :string(255)

#

class User < ActiveRecord::Base
  unless @domain_root_account.nil?
  default_scope User.joins(:account_users).where('account_users.account_id = ?', @domain_root_account.id )
  end
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me

  include CasHelper
  include LmsHelper
  attr_accessible :role_ids, :as => :admin
  attr_accessible :attachment,:content_type,:image_blob,:lms_id,:name, :email, :password, :password_confirmation,
                  :remember_me, :omni_image_url, :phone,:user_type,:sub_plan,:user_desc, :provider,:subtype, :uid,
                  :reset_password_sent_at

  has_many :authentication, :dependent => :delete_all
  has_many :comments
  has_one  :student
  has_many :invoices
  has_many :account_users
  has_one  :teaching_staff , dependent: :destroy
  accepts_nested_attributes_for :teaching_staff
  def teachingdetails
   self.teaching_staff_courses.where(:teaching_staff_type => "teacher_assitant")
  end


 letsrate_rater
 def apply_omniauth(auth)
	  # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.email    = auth['info']['email']
    self.name     = auth['info']['name']
    self.omni_image_url = auth['info']['image']
    self.phone    = auth['info']['phone']
    self.provider = auth['provider']
    
    require 'bcrypt'

    pepper = nil
    cost = 10
    encrypted_password = ::BCrypt::Password.create("#{Time.now.to_s}#{pepper}", :cost => cost).to_s
    self.encrypted_password = encrypted_password

	  # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
	  authentication.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
	end

  def attachment=(incoming_file)
    if incoming_file!=nil && incoming_file != ""
      self.content_type = incoming_file.content_type
      self.image_blob = incoming_file.read
    end
  end

  before_destroy :delete_in_lms
  def delete_in_lms
    if lms_enable? 
      lmsuser=CanvasREST::User.new
      lmsuser.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
      lmsuser.delete_user(Settings.lms.account_id,self.lms_id)
    end
  end

  def self.insert_user_role(user_id,role_id)
    find_by_sql("insert into users_roles(user_id,role_id) values(#{user_id},#{role_id})")  
  end

end

