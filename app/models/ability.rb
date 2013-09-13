class Ability
  include CanCan::Ability
  
  def initialize(user)

    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
      cannot :my_courses, Course
      elsif user.has_role? :teacher
        can [:new,:create, :edit,:update, :destroy,:manage_courses,:course_status_search,
             :completed_courses,:updatecompleted_details,:conclude_course,:concluded_course_update], Course
        can :read, :all
    end

  end


end

