class UsersController < ApplicationController

  def show
    @user = User.find_by(id: current_user.id)
    @members = Member.where(user_id: current_user.id)
    @brochures = []
    @members.each do |member|
      @brochures.push(Brochure.find_by(id: member.brochure_id))
    end
  end

end
