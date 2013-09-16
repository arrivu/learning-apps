class CouponsController < ApplicationController
	require 'csv'
  require 'errors'
  load_and_authorize_resource
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:apply,:redeem,:index]
  before_filter :valid_domain_check, :only=>[:edit]
  def apply
    no_coupon = Coupon.no_coupon(params[:product_bag])
    respond_to do |wants|
      wants.js do
        begin
          response = Coupon.apply(params[:coupon_code], params[:product_bag])
        rescue CouponNotFound
          response = {"error" => "Coupon not found" }.merge(no_coupon)
        rescue CouponNotApplicable
          response = {"error" => "Coupon does not apply" }.merge(no_coupon)
        rescue CouponRanOut
          response = {"error" => "Coupon has run out"}.merge(no_coupon)
        rescue CouponExpired
          response = {"error" => "Coupon has expired"}.merge(no_coupon)
        end
        render :text => response.to_json
      end
    end
  end
  
  def redeem
    respond_to do |wants|
      wants.js do
        Coupon.redeem(params[:coupon_code], params[:user_id], params[:tx_id], params[:metadata],params[:account_id]).to_json
      end
    end
  end
  
  def new
    find_or_generate_coupon
    populate_combo_courses
  end

  def edit
     @coupon = Coupon.find(params[:id])
     populate_combo_courses
  end

  def update
     
        @coupon = Coupon.find(params[:id])
        if  @coupon.update_attributes(params[:coupon])
          
          flash[:notice] = "update coupons"
          #flash[:coupon_notice] = "Created #{create_count} coupons"
          redirect_to coupons_path
        else
          #flash[:notice] ||= 'Please fix the errors below'
          render :action => "edit"
        end
  end
  
  def index
    find_or_generate_coupon
    
    if params[:after]
      @coupons = Coupon.where(["id >= ? and account_id=?", params[:after],@domain_root_account.id]).paginate(page: params[:page], per_page: 10)
    else
      @coupons = @domain_root_account.coupons.paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(:force_quotes => true) do |csv|
              csv << ["name","description", "alpha_code", "alpha_mask", "digit_code", "digit_mask", "category_one", "amount_one", "percentage_one", "category_two", "amount_two", "percentage_two", "expiration", "how_many", "redemptions_count"]
              @coupons.each do |c|
                csv << [c.name, c.description, c.alpha_code, c.alpha_mask, c.digit_code, c.digit_mask, c.category_one, c.amount_one, c.percentage_one, c.category_two, c.amount_two, c.percentage_two, c.expiration, c.how_many, c.redemptions_count]
              end
            end
            send_data csv_string, :type => "text/plain",
                                  :filename=>"coupons.csv",
                                  :disposition => 'attachment'
      end
    end
  end
  
  def create
    respond_to do |format|
      format.html do
        populate_combo_courses
        params[:coupon][:account_id]=@domain_root_account.id
        @coupon = Coupon.new(params[:coupon])
        how_many = params[:how_many] || 1
        unless Coupon.enough_space?(@coupon.alpha_mask, @coupon.digit_mask, Integer(how_many))
          @coupon.errors.add(:alpha_mask, " Alpha/digit mask is not long enough")
          @coupon.errors.add(:digit_mask, " Alpha/digit mask is not long enough")
        end
        if Integer(params[:how_many]) < 0
          @coupon.errors.add(:base, "How many must be positive")
          flash[:coupon_error] = "How many must be positive"
        end
        if @coupon.errors.empty? && @coupon.valid?
          create_count = 0
          Integer(how_many).times do |i|
             params[:coupon][:account_id]=@account_id
            coupon = Coupon.new(params[:coupon])
            if coupon.save
              @first_coupon ||= coupon.id
              create_count += 1
            end
          end
          flash[:notice] = "Created #{create_count} coupons"
          #flash[:coupon_notice] = "Created #{create_count} coupons"
          redirect_to coupons_path(:after => @first_coupon)
        else

          #flash[:coupon_error] ||= 'Please fix the errors below'
          render :action => "new"
        end
      end
    end
    
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    redirect_to coupons_path
  end
  
  private
  
  
  def find_or_generate_coupon
      @coupon ||= Coupon.new
  end

  def populate_combo_courses
    if current_user.has_role? :teacher
      @courses=[]
      current_user.teaching_staff.teaching_staff_courses.each do |c|
        @courses << c.course
      end

      else
        @courses = @domain_root_account.courses
    end
  end

end
