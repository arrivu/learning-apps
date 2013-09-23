class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.has_role? :admin or user.has_role? :account_admin
      can :manage, :all
      cannot :my_courses, Course
    elsif user.has_role? :teacher
        can :manage, Course
        can [:show_image_detail,:theme_image_detail,:show_image_show,:theme_image_show],HeaderDetail
        can :manage, CoursePricing
        can :manage ,CoursePreview
        can :manage ,Coupon
        can :manage,TeachingStaff

    else
      can [:show_image,:background_image,:index,:show,:tagged_courses,:get_modules,:datewise_courses,:popular_courses,:upcomming_courses,:subscribed_courses],Course
      can :manage,TeachingStaff
      can [:show_image_detail,:theme_image_detail,:show_image_show,:theme_image_show],HeaderDetail
      can [:teaching_staff_signup] ,TeachingStaff
      can [:account_subscription] ,Account
      can :terms ,TermsAndCondition
      can :show ,Topic
    end

  end


end

