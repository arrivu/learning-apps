module CoursePricingsHelper
	def nooverlap?(course_ids,start_date,end_date)
		course_ids.each do |course|
			start_date1=Date.parse(course.start_date.to_s)
			end_date1=Date.parse(course.end_date.to_s)
			start_date=Date.parse(start_date.to_s)
			end_date=Date.parse(end_date.to_s)
			account_id=course.account_id
			if account_id==@account_id
			return unless((start_date1..end_date1).to_a & (start_date..end_date).to_a).empty?
		end
		end
	end

  def populate_course_pricing
    if current_user.has_role? :teacher
      @coursepricings=[]
      current_user.teaching_staff.teaching_staff_courses.each do |c|
        c.course.course_pricings.each do |course_pricing|
          @coursepricings << course_pricing
          end
      end

    elsif current_user.has_role? :admin or current_user.has_role? :account_admin
      @coursepricings = @domain_root_account.course_pricings.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 30)
    end
  end

end



