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
  end

  # GET /brochures/new
  def new
    @brochure = Brochure.new
  end

  # GET /brochures/1/edit
  def edit
    @brochure = Brochure.find(params[:id])
    @days = Day.where(brochure_id: @brochure.id).order(start_time: :asc)

  end

  # POST /brochures
  # POST /brochures.json
  def create
    @brochure = Brochure.new(brochure_params)
    @member = Member.new
    @spot = Spot.new

    respond_to do |format|
      if @brochure.save
        @member.user_id = current_user.id
        @member.brochure_id = @brochure.id
        @member.save
        # times.each使って、招待者数繰り返す（member.user_id / @member.brochure_id）.

        brochure_params[:duration].to_i.times.each do |n|
          # @day.brochure_id = @brochure.id
          # @day.save
          @day = Day.create(brochure_id: @brochure.id, start_time: @brochure.start_date + 60*60*10 + 60*60*24*n)

        end

        @spot.day_id = @day.id
        @spot.save

        format.html { redirect_to @brochure, notice: 'Brochure was successfully created.' }
        format.json { render :show, status: :created, location: @brochure }
      else
        format.html { render :new }
        format.json { render json: @brochure.errors, status: :unprocessable_entity }
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
      format.html { redirect_to brochures_url, notice: 'Brochure was successfully destroyed.' }
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
      params.require(:brochure).permit(:title, :departure, :arrival, :start_date, :duration)
    end
end
