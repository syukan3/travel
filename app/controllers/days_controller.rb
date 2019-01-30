class DaysController < ApplicationController
  before_action :set_day, only: [:destroy]

  def create
    @day = Day.create(brochure_id: @brochure.id, start_time: @brochure.start_date + 60*60*10 + 60*60*24*n)

  end


  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day
      @day = Brochure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.require(:day).permit(:start_time)
    end
end
