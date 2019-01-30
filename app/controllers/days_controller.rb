class DaysController < ApplicationController
  before_action :set_day, only: [:destroy]

  def create
    @brochure = Brochure.find_by(id: params[:brochure_id])
    @day = Day.create(brochure_id: params[:brochure_id], start_time: @brochure.start_date + 60*60*10 + 60*60*24*@brochure.duration)
    @brochure.duration += 1
    if @day.save
      @brochure.save
      redirect_to(edit_brochure_path(@brochure))
    else
      render(edit_brochure_path(@brochure))
    end
  end

  def update

  end

  def destroy
    original_days = Day.where(brochure_id: params[:brochure_id]).order(start_time: :asc)
    n = 0
    diff = []
    original_days.each do |original_day|
      if @day.start_time < original_day.start_time then
        date = original_day.start_time.to_date
        diff[n] = original_day.start_time - date.to_datetime
        n = n + 1
      else
        next
      end
    end

    @day.destroy
    @days = Day.where(brochure_id: params[:brochure_id]).order(start_time: :asc)
    @brochure = Brochure.find_by(id: params[:brochure_id])
    @brochure.duration -= 1
    @brochure.save

    n = 0
    @days.each do |day|
      if @day.start_time < day.start_time then
        day.start_time = @brochure.start_date + diff[n] + 60*60*24*n
        day.save
        n = n + 1
      else
        next
      end
    end

    respond_to do |format|
      format.html { redirect_to edit_brochure_path(@brochure), notice: 'Day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day
      @day = Day.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.require(:day).permit(:start_time)
    end
end
