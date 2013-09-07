class UserMailer < ActionMailer::Base
  
 default :from => "arrivusystems@gmail.com"
  
  def course_payment(user,course,price)
  	@email = user.email
    @price =price
    @name = user.name
    path = "#{Rails.root}/tmp/invoice_course_id_#{course.id}_user_id_#{user.id}.pdf"
    attachments['Invoice.pdf'] = File.read(path)
    mail(:to => "#{@email}", :subject => "Payment succesfully transfer")
  end
  
  def mail_contact(name,email,message)
  	message="Name: #{name}\nEmail: #{email}\nMessage:\n#{message}" 
  	mail(:to => Settings.admin_mail.to, :subject => "Contact Us",:body => message)
  end

  def teaching_staffs_activation(teaching_staff)
    @teaching_staff =teaching_staff
    mail(:to => teaching_staff.user.email, :subject => "Account Activation")
  end
  
end
