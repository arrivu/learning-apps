module CouponsHelper
  def populate_coupons
    if current_user.has_role? :teacher
      @coupons = current_user.teaching_staff.coupons.paginate(page: params[:page], per_page: 30)
    else
      @coupons = @domain_root_account.coupons.paginate(page: params[:page], per_page: 30)
    end
  end
end
