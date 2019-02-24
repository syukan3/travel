class SpotsController < ApplicationController
  before_action :set_spot, only: [:destroy, :update, :edit]

  def create
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)
    spots = Spot.where(day_id: @day.id)

    # ↓ AutoComplete から location_name/time_required/lat/lng を params で受け取る。
    @spot = Spot.new(day_id: @day.id, location_name: params[:spot], stay_time: 60, position: spots.count+1, lat: params[:lat], lng: params[:lng])
    if @spot.save
      redirect_to(edit_brochure_path(@brochure))
    else
      format.html { render action: "create" }
      format.json { render json: edit_brochure_path(@brochure).errors, status: :unprocessable_entity }
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
    spots = Spot.where(day_id: @day.id).order(position: :asc)
    spots.each.with_index do |spot, num|
      spot.position = num + 1
      spot.save
    end
    respond_to do |format|
      format.html { redirect_to edit_brochure_path(@brochure), notice: 'Spot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def spot_higher
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)
    Spot.find(params[:id]).move_higher
    redirect_to edit_brochure_path(@brochure)
  end

  def spot_lower
    @day = Day.find_by(id: params[:day_id])
    @brochure = Brochure.find_by(id: @day.brochure_id)
    Spot.find(params[:id]).move_lower
    redirect_to edit_brochure_path(@brochure)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_params
      params.require(:spot).permit(:location_name, :position, :lat, :lng, :stay_time)
    end

end
