class StudentsController < ApplicationController

  def index
    @students=@domain_root_account.students.order('created_at').paginate(page: params[:page], :per_page => 30)
  end

  def activate_students
    @student=Student.find(params[:id])
    @student.is_active = params[:student][:is_active]
    if @student.save!
      if @student.is_active?
        unless Rails.env.development?
          UserMailer.delay.student_activation(@student)
        end
        redirect_to students_path
        flash[:success] = "Student Sucessfully activated and activation mail sent !"
      else
        redirect_to students_path
        flash[:info] = "Student Sucessfully Updated"
      end
    end

  end

  def destroy
  @student=Student.find(params[:id])
  @account_user = AccountUser.find_by_account_id_and_user_id(@domain_root_account.id,@student.user.id)
    if @account_user.destroy  and @student.destroy
      flash[:success] = "User destroyed permanently"
      redirect_to students_path
    else
      flash[:success] = "There is some error when deleting the user"
      redirect_to students_path
    end
  end
end
