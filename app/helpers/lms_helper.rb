module LmsHelper
	include BooleanHelper

	def lms_enable?
		parse_boolean "#{Settings.lms.enable}"
	end

	def lms_course_url(lms_id)
		"#{Settings.lms.root_url}#{Settings.lms.course_url_path}#{lms_id}"
	end
	
	def lms_logout
		"#{Settings.lms.root_url_logout}"
	end

	def lms_logout_url()
		"#{Settings.lms.root_url}#{Settings.lms.logout_path}"
	end

	def lms_create_user(current_user)
		if lms_enable? and current_user != nil
			lmsuser=CanvasREST::User.new
			lmsuser.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			u=lmsuser.create_user(Settings.lms.account_id,current_user.name,current_user.email,current_user.password)
			current_user.update_attributes(:lms_id => u["id"])
		end
	end

	def lms_create_course(course)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			c=lmscourse.create_course(Settings.lms.account_id,course.id,course.title,course.desc)
			@course.update_attributes(:lms_id => c["id"])
            course.teaching_staffs.each do |teaching_staff|
              lmscourse.enroll_user(course.lms_id,teaching_staff.user.lms_id,'TeacherEnrollment')
            end

		end
	end
	def lms_enroll_student(course_id,user_id)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			lmscourse.enroll_user(course_id,user_id)
		end
	end

	def lms_conclude_enrollment(course_id,user_id)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			lmscourse.conclude_enrollment(course_id,user_id)
		end
	end	

	def lms_conclude_course(course_id)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			lmscourse.conclude_course(course_id)
		end
	end	

	

	def lms_update_course(course,old_teaching_staff_id=nil)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			lmscourse.update_course(course.lms_id,course.title,course.desc)
        unless params[:course][:teaching_staff_ids].to_i == old_teaching_staff_id[0]
          lms_update_teacher_enrollment(course,old_teaching_staff_id)
        end
      end
		end


	def lms_delete_course(lms_id)
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			lmscourse.delete_course(lms_id)
		end
	end

	def lms_get_modules(course)
		modules=[]
		if lms_enable? 
			lmscourse=CanvasREST::Course.new
			lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
			course=lmscourse.get_course(course.lms_id)
			modules=course.modules
    else
			modules
		end
  end

  def lms_update_teacher_enrollment(course,old_teaching_staff_id)
    lmscourse=CanvasREST::Course.new
    lmscourse.set_token(Settings.lms.oauth_token,Settings.lms.api_root_url)
    lms_conclude_enrollment(course.lms_id,TeachingStaff.find(old_teaching_staff_id[0]).user.lms_id)
    lmscourse.enroll_user(course.lms_id,course.teaching_staffs[0].user.lms_id,"TeacherEnrollment","active")
  end
end