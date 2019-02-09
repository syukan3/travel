class SpotsController < ApplicationController
  before_action :set_spot, only: [:destroy, :update, :edit]

  def create
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)

    # ↓ AutoComplete から location_name/time_required/lat/lng を params で受け取る。
    @spot = Spot.new(day_id: @day.id, location_name: params[:spot], stay_time: 60)
    if @spot.save
      redirect_to(edit_brochure_path(@brochure))
    else
      render(edit_brochure_path(@brochure))
    end
  end

  def edit
    @spot = Spot.find_by(id: params[:id])
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)

  end

  def update
    @brochure = Brochure.find_by(id: @spot.day.brochure_id)
    respond_to do |format|
      if @spot.update_attributes(spot_params)
        format.html { redirect_to edit_brochure_path(@brochure), notice: 'Spot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: edit_brochure_path(@brochure).errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)
    @spot.destroy
    respond_to do |format|
      format.html { redirect_to edit_brochure_path(@brochure), notice: 'Spot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_params
      params.require(:spot).permit(:location_name, :numbering, :lat, :lng, :stay_time)
    end

end
