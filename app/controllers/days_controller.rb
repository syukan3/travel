class DaysController < ApplicationController
  before_action :set_day, only: [:destroy, :update, :edit]

  def create
    @brochure = Brochure.find_by(id: params[:brochure_id])
    @day = Day.create(brochure_id: params[:brochure_id], start_time: @brochure.start_date + 60*60*10 + 60*60*24*@brochure.duration)
    if @day.save
      @brochure.duration += 1
      @brochure.save
      redirect_to(edit_brochure_path(@brochure))
    else
      render(edit_brochure_path(@brochure))
    end
  end

  def edit
    @day = Day.find_by(id: params[:id])
    @brochure = Brochure.find_by(id: @day.brochure_id)

  end

  def update
    def hour_check(input)
      array = input.split(":")
    end
    @brochure = Brochure.find_by(id: @day.brochure_id)
    respond_to do |format|
      if @day.update(start_time: @day.start_time.change(hour: hour_check(day_params[:start_time])[0].to_i, min: hour_check(day_params[:start_time])[1].to_i))
        format.html { redirect_to edit_brochure_path(@brochure), notice: 'Spot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: edit_brochure_path(@brochure).errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    original_days = Day.where(brochure_id: params[:brochure_id]).order(start_time: :asc)
    n = 0
    m = 0
    diff = []
    original_days.each do |original_day|
      if @day.start_time < original_day.start_time then
        date = original_day.start_time.to_date
        diff[n] = original_day.start_time - date.to_datetime
        n = n + 1
      else
        m = m + 1
        next
      end
    end

    @day.destroy
    days = Day.where(brochure_id: params[:brochure_id]).order(start_time: :asc)
    @brochure = Brochure.find_by(id: params[:brochure_id])
    @brochure.duration -= 1
    @brochure.save

    n = 0
    days.each do |day|
      if @day.start_time < day.start_time then
        day.start_time = @brochure.start_date + diff[n] + 60*60*24*(m-1)
        day.save
        m = m + 1
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

  def higher
    @day = Day.find_by(id: params[:day_id])
    @brochure = @day.brochure
    @day.move_higher
    redirect_to edit_brochure_path(@brochure)
  end

  def lower
    @day = Day.find_by(id: params[:day_id])
    @brochure = @day.brochure
    @day.move_lower
    redirect_to edit_brochure_path(@brochure)
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
