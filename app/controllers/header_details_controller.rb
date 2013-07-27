class HeaderDetailsController < ApplicationController
  
  def new
  	@header_detail = HeaderDetail.new
  end

  def create
  	@header_detail = HeaderDetail.new(params[:header_detail])
  	if @header_detail.save
  		flash[:save] = "Successfully create"
  		redirect_to header_details_path
  end

  def edit
  end

  def show
  end

  def index
  end
end
