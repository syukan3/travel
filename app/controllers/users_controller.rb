class UsersController < ApplicationController

  def show
    @user = User.find_by(id: current_user.id)
    @brochure = Brochure.find_by(id: pawams[:id])
    
  end

end
