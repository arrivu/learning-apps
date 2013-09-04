class ThemeController < ApplicationController
  before_filter :check_admin_user
  def new
    @theme =Theme.new
  end

  def create

  end

  def index

  end

  def edit

  end

  def update

  end

  def destroy

  end
  def check_admin_user
    authenticate_user!
    if current_user.has_role? :account_admin
      return
    elsif current_user.has_role? :admin
      return
    else

      redirect_to root_url # or whatever
    end

  end
end
