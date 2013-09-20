module CoursePreviewsHelper
  def populate_course_previews
    if current_user.has_role? :teacher
      @previews=[]
      current_user.teaching_staff.teaching_staff_courses.each do |tc|
        tc.course.course_previews.each do |course_preview|
          @previews << course_preview
        end
      end

    elsif current_user.has_role? :admin or current_user.has_role? :account_admin
      @previews = @domain_root_account.course_previews.paginate(page: params[:page], :per_page => 30)
    end
  end

end
