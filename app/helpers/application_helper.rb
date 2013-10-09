module ApplicationHelper
		# Returns the full title on a per-page basis.
		def full_title(page_title)
			base_title = "Arrivu Apps Learning Portal"
			@page_title = page_title
			if page_title.empty?
				base_title
			else
				"#{base_title} | #{page_title}"
			end
		end

		def check_null(str)
			if str.empty?
				true
			else
				false
			end
		end

		def display_base_errors resource
			return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
			messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
			html = <<-HTML
			<div class="alert alert-error alert-block">
				<button type="button" class="close" data-dismiss="alert">&#215;</button>
				#{messages}
			</div>
			HTML
			html.html_safe
		end

		def check_admin_user
			authenticate_user!
			if current_user.has_role? :account_admin 
			 return
			elsif current_user.has_role? :admin
				return
      elsif current_user.has_role? :teacher
        return
			else
     redirect_to root_url # or whatever
   end
end


  def http_cache(instant_variable,scope=true,expires=15)
    unless RAILS.env.development?
      expires_in expires.minutes
      fresh_when instant_variable, public: scope
    end
  end
      #  def http_cache(instant_variable,scope=true)
      #    fresh_when instant_variable, public: scope
      #  end
  def theme_check_account_admin
      authenticate_user!
      if current_user.has_role? :account_admin 
       return
      
      else  

     redirect_to root_url # or whatever
   end
 end

 

 def theme_check_create_admin
      authenticate_user!
      if current_user.has_role? :admin 
       return
      
      else  

     redirect_to root_url # or whatever
   end
 end

  def subdomain_authentication
       :authenticate_user!
       if current_user.has_role? :student
       	  if !@subdomain_id= AccountUser.where(:user_id=>current_user.id , :account_id=>@account_id).empty?
        	return
      		else
      			 @subdomain_id= AccountUser.find_by_user_id(current_user.id)
        	redirect_to request.url.sub(current_subdomain, @subdomain_id.account.name)
      		end
      elsif !current_user.has_role?  :admin
       @subdomain_id= AccountUser.find_by_user_id(current_user.id)
        @subdomain_name=Account.find_by_name(@subdomain_id.account_id)
      if  @account_id==@subdomain_id.account_id
        return
      else
        redirect_to request.url.sub(current_subdomain, @subdomain_id.account.name)
        # redirect_to root_path(:subdomain => @subdomain_name)
      end

     end
   end



      def totalmodulescount
        modules_count=0
        @domain_root_account=Account.find_by_name(current_subdomain)
        @courses=@domain_root_account.courses
        @courses.each do |course|
          modules=lms_get_modules(course).count
          if modules == nil
            modules_count=0
          else
            modules_count+=modules
          end

        end
          modules_count

      end


 def distance_of_time_in_words(from_time, to_time = 0, include_seconds_or_options = {}, options = {})
  if include_seconds_or_options.is_a?(Hash)
    options = include_seconds_or_options
  else
    ActiveSupport::Deprecation.warn "distance_of_time_in_words and time_ago_in_words now accept :include_seconds " +
                                    "as a part of options hash, not a boolean argument"
    options[:include_seconds] ||= !!include_seconds_or_options
  end

  options = {
    scope: :'datetime.distance_in_words'
  }.merge!(options)

  from_time = from_time.to_time if from_time.respond_to?(:to_time)
  to_time = to_time.to_time if to_time.respond_to?(:to_time)
  from_time, to_time = to_time, from_time if from_time > to_time
  distance_in_minutes = ((to_time - from_time)/60.0).round
  distance_in_seconds = (to_time - from_time).round

  I18n.with_options :locale => options[:locale], :scope => options[:scope] do |locale|
    case distance_in_minutes
      when 0..1
        return distance_in_minutes == 0 ?
               locale.t(:less_than_x_minutes, :count => 1) :
               locale.t(:x_minutes, :count => distance_in_minutes) unless options[:include_seconds]

        case distance_in_seconds
          when 0..4   then locale.t :less_than_x_seconds, :count => 5
          when 5..9   then locale.t :less_than_x_seconds, :count => 10
          when 10..19 then locale.t :less_than_x_seconds, :count => 20
          when 20..39 then locale.t :half_a_minute
          when 40..59 then locale.t :less_than_x_minutes, :count => 1
          else             locale.t :x_minutes,           :count => 1
        end

      when 2...45           then locale.t :x_minutes,      :count => distance_in_minutes
      when 45...90          then locale.t :about_x_hours,  :count => 1
      # 90 mins up to 24 hours
      when 90...1440        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
      # 24 hours up to 42 hours
      when 1440...2520      then locale.t :x_days,         :count => 1
      # 42 hours up to 30 days
      when 2520...43200     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
      # 30 days up to 60 days
      when 43200...86400    then locale.t :about_x_months, :count => (distance_in_minutes.to_f / 43200.0).round
      # 60 days up to 365 days
      when 86400...525600   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
      else
        if from_time.acts_like?(:time) && to_time.acts_like?(:time)
          fyear = from_time.year
          fyear += 1 if from_time.month >= 3
          tyear = to_time.year
          tyear -= 1 if to_time.month < 3
          leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
          minute_offset_for_leap_year = leap_years * 1440
          # Discount the leap year days when calculating year distance.
          # e.g. if there are 20 leap year days between 2 dates having the same day
          # and month then the based on 365 days calculation
          # the distance in years will come out to over 80 years when in written
          # english it would read better as about 80 years.
          minutes_with_offset = distance_in_minutes - minute_offset_for_leap_year
        else
          minutes_with_offset = distance_in_minutes 
        end
        remainder                   = (minutes_with_offset % 525600)
        distance_in_years           = (minutes_with_offset.div 525600)
        if remainder < 131400
          locale.t(:about_x_years,  :count => distance_in_years)
        elsif remainder < 394200
          locale.t(:over_x_years,   :count => distance_in_years)
        else
          locale.t(:almost_x_years, :count => distance_in_years + 1)
        end
    end
  end
end


  


    def populate_combo_courses
      if current_user.has_role? :teacher
        @courses=[]
        current_user.teaching_staff.teaching_staff_courses.each do |c|
          @courses << c.course
        end

      elsif current_user.has_role? :admin or current_user.has_role? :account_admin
        @courses = @domain_root_account.courses
      end
    end

  def user_can_do?(context)
    if context.class == Course
    current_user.has_role? :admin or current_user.has_role? :account_admin or !TeachingStaffCourse.where(:course_id =>
                                          context.id,:teaching_staff_id =>current_user.teaching_staff.id).blank?
    elsif context.class == Coupon
      current_user.has_role? :admin or current_user.has_role? :account_admin or
           context.teaching_staff_id==current_user.teaching_staff.id
    else
    current_user.has_role? :admin or current_user.has_role? :account_admin or !TeachingStaffCourse.where(:course_id =>
                                        context.course.id,:teaching_staff_id =>current_user.teaching_staff.id).blank?
    end
  end


def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
    @object = rateable_obj
    @user = rating_user
    @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension(@user.id, @object.id, dimension)
    stars = @rating ? @rating.stars : 0


    disable_after_rate = options[:disable_after_rate] || false
    
    readonly=false
    if disable_after_rate
      readonly = current_user.present? ? !rateable_obj.can_rate?(current_user.id, dimension) : true
    end
 
    content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => stars,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                "data-disable-after-rate" => disable_after_rate,
                "data-readonly" => readonly,
                "data-star-count" => stars
  end


    def verify_user_status(action=nil)
      if current_user.has_role?  :student and !current_user.student.is_active?
        clear_user_session(action)
      elsif current_user.has_role?  :teacher and !current_user.student.is_active?
        clear_user_session(action)
      end
    end

    def clear_user_session(action=nil)
      reset_session
      if action=="sign-in"
      flash[:error] = "Your Account Not yet activated, Please contact admin "
      else
        flash[:info] = "Account has been created.However you cannot login now ,Once your Account is verified the admin
                        will contact you !"
      end
    end

end
