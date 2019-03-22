class HomeController < ApplicationController
  def top
    @brochures = Brochure.where(public_flag: true).order(start_date: :asc)
    if user_signed_in?
      @members = Member.where(user_id: current_user.id)
    end
  end
end
