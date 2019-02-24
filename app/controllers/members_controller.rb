class MembersController < ApplicationController
  before_action :set_member, only: [:edit]


  def index
    @member = Member.new
    @members = Member.where(brochure_id: params[:brochure_id])
    @users = User.all
    @brochure = Brochure.find_by(id: params[:brochure_id])
  end

  def create

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:user_id, :brochure_id)
    end
end
