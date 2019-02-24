require 'httpclient'
class BrochuresController < ApplicationController
  before_action :set_brochure, only: [:show, :edit, :update, :destroy]

  # GET /brochures
  # GET /brochures.json
  def index
    @brochures = Brochure.all
  end

  # GET /brochures/1
  # GET /brochures/1.json
  def show
    @brochure = Brochure.find(params[:id])
    @days = Day.where(brochure_id: @brochure.id).order(start_time: :asc)
    @durations = Array.new(@days.length)
    @members = Member.where(brochure_id: params[:id])


    @days.each.with_index do |day, n|
      spots = Spot.where(day_id: day.id).order(position: :asc)
      last_spot = nil

      if spots.length-1 > 0
        @durations[n] = Array.new(spots.length-1)
      end

      spots.each.with_index do |spot, num|
        if num != 0 then
          base_url="https://maps.googleapis.com/maps/api/directions/json?origin=" + last_spot.lat.to_s + "," + last_spot.lng.to_s + "&destination=" + spot.lat.to_s + "," + spot.lng.to_s + "&mode=driving&key=" + Rails.application.credentials.google_map_key
          client = HTTPClient.new()
          response = client.get(base_url)
          @durations[n][num-1] = JSON.parse(response.body)['routes'][0]['legs'][0]['duration']['text'].split.first.to_i
          last_spot = Spot.find_by(id: spot.id)
        else
          last_spot = Spot.find_by(id: spot.id)
        end
      end
    end
  end

  # GET /brochures/new
  def new
    @brochure = Brochure.new
  end

  # GET /brochures/1/edit
  def edit

    @brochure = Brochure.includes(:members).where(members: {user: current_user}).find(params[:id])
    @days = Day.where(brochure_id: @brochure.id).order(position: :asc)
    @durations = Array.new(@days.length)
    @members = Member.where(brochure_id: params[:id])

    def minutes_changer(input)
      if input.length == 2 then
        result = input[0].to_i
        return result
      elsif input.length == 4
        result = input[0].to_i * 60 + input[2].to_i
        return result
      end
    end

    @days.each.with_index do |day, n|
      spots = Spot.where(day_id: day.id).order(position: :asc)
      last_spot = nil

      if spots.length-1 > 0
        @durations[n] = Array.new(spots.length-1)
      end

      spots.each.with_index do |spot, num|
        if num != 0 then
          base_url="https://maps.googleapis.com/maps/api/directions/json?origin=" + last_spot.lat.to_s + "," + last_spot.lng.to_s + "&destination=" + spot.lat.to_s + "," + spot.lng.to_s + "&mode=driving&key=" + Rails.application.credentials.google_map_key
          client = HTTPClient.new()
          response = client.get(base_url)
          @durations[n][num-1] = minutes_changer(JSON.parse(response.body)['routes'][0]['legs'][0]['duration']['text'].split)
          last_spot = Spot.find_by(id: spot.id)
        else
          last_spot = Spot.find_by(id: spot.id)
        end
      end
    end
  end



  # POST /brochures
  # POST /brochures.json
  def create
    @brochure = Brochure.new(brochure_params)
    @member = Member.new

    respond_to do |format|
      if @brochure.save
        @member.user_id = current_user.id
        @member.brochure_id = @brochure.id
        @member.save
        # times.each使って、招待者数繰り返す（member.user_id / @member.brochure_id）.

        brochure_params[:duration].to_i.times.each.with_index(1) do |n, index|
          @day = Day.create(brochure_id: @brochure.id, start_time: @brochure.start_date + 60*60*10 + 60*60*24*n, position: index)
        end

        format.html { redirect_to edit_brochure_path(@brochure), notice: 'Brochure was successfully created.' }
        format.json { render :show, status: :created, location: @brochure }
      else
        format.html { render :new }
        format.json { render json: edit_brochure_path(@brochure).errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brochures/1
  # PATCH/PUT /brochures/1.json
  def update
    respond_to do |format|
      original_days = Day.where(brochure_id: @brochure.id).order(start_time: :asc)
      n = 0
      diff = []
      original_days.each do |original_day|
        date = original_day.start_time.to_date
        diff[n] = original_day.start_time - date.to_datetime
        n = n + 1
      end

      if @brochure.update(brochure_params)
        if brochure_params[:public_flag].nil?
          @brochure.update(public_flag: nil)
        end
        @days = Day.where(brochure_id: @brochure.id).order(start_time: :asc)
        n = 0
        @days.each do |day|
          day.start_time = @brochure.start_date + diff[n] + 60*60*24*n
          day.save
          n = n + 1
        end

        format.html { redirect_to @brochure, notice: 'Brochure was successfully updated.' }
        format.json { render :show, status: :ok, location: @brochure }
      else
        format.html { render :edit }
        format.json { render json: @brochure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brochures/1
  # DELETE /brochures/1.json
  def destroy
    @brochure.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: 'Brochure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brochure
      @brochure = Brochure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brochure_params
      params.require(:brochure).permit(:title, :start_date, :duration, :public_flag)
    end
end
