class Ability
  include CanCan::Ability
  
  def initialize(user)

    user ||= User.new
    if user.has_role? :admin or user.has_role? :account_admin
      can :manage, :all
      cannot :my_courses, Course
    elsif user.has_role? :teacher
        can [:new,:create,:edit,:update, :destroy,:manage_courses,:course_status_search,
             :completed_courses,:updatecompleted_details,:conclude_course,:concluded_course_update], Course
        
        can [:show_image,:background_image,:index,:show,:my_courses,:review],Course
        can [:show_image_detail,:theme_image_detail,:show_image_show,:theme_image_show],HeaderDetail
        can :manage, CoursePricing
        can :manage ,CoursePreview
        can :manage ,Coupon

    else

      can [:show_image,:background_image,:index,:show,:review],Course
      can [:show_image_detail,:theme_image_detail,:show_image_show,:theme_image_show],HeaderDetail
      can [:teaching_staff_signup] ,TeachingStaff
    end

  end


end

