class ApiController < ApplicationController
  def set_spot
    @day = Day.find_by(id: params[:day_id])
    @brochure = @day.brochure
    spots = Spot.where(day_id: @day.id)

    base_url="https://maps.googleapis.com/maps/api/geocode/json?latlng="+params[:lat]+","+params[:lng]+"&key="+Rails.application.credentials.google_map_key
    client = HTTPClient.new()
    response = client.get(base_url)
    location_name = JSON.parse(response.body)['results'][0]['formatted_address']

    # @spot = Spot.new(day_id: @day.id, location_name: location_name, stay_time: 60, position: spots.count+1, lat: params[:lat], lng: params[:lng])
    # if @spot.save
    #   redirect_to(edit_brochure_path(@brochure))
    # else

    # render json: { status: 'ok' }
    render json: { day_id: params[:day_id], location_name: location_name, lat: params[:lat], lng: params[:lng] }
  end
end
