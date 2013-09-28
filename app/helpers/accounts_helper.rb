module AccountsHelper

  CHARS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  def generate_securish_uuid(length = 40)
    Array.new(length) { CHARS[SecureRandom.random_number(CHARS.length)] }.join
  end

  def generate_random(purpose = nil, length = 4)
    slug = ''
    slug << purpose << '-' if purpose
    slug << generate_securish_uuid(length)
    slug
  end

  def create_subscription_authentication(account_name,email,password,token)
    authenticate_subscription=AuthenticateSubscription.new
    authenticate_subscription.account_name = account_name
    authenticate_subscription.email = email
    authenticate_subscription.password = password
    authenticate_subscription.token =token
    authenticate_subscription.save!
  end

  def  authenticate
    unless params[:cross_domain_login_token].nil?
      if authenticate_subscription = AuthenticateSubscription.find_by_token(params[:cross_domain_login_token]) && AuthenticateSubscription.find_by_account_name(current_subdomain)
        reset_session
        @user=User.find_by_email(authenticate_subscription.email)
        sign_in @user
        account_name=authenticate_subscription.account_name
        authenticate_subscription.destroy
        UserMailer.delay.account_subscription_welcome(account_name,@user)
        flash[:info]="You are subscribed Successfully. You can customize the basic pages like upload your own logo and all static pages"
        redirect_to users_path
      end
    end
  end


end
