class Api::SpotsController < ApplicationController
  def create
    @day = Day.find_by(id: params[:day_id])
    @brochure = @day.brochure
    spots = Spot.where(day_id: @day.id)

    base_url="https://maps.googleapis.com/maps/api/geocode/json?latlng="+params[:lat].to_s+","+params[:lng].to_s+"&key="+Rails.application.credentials.google_map_key
    client = HTTPClient.new()
    response = client.get(base_url)
    location_name = JSON.parse(response.body)['results'][0]['formatted_address']

    @spot = Spot.new(day_id: @day.id, location_name: location_name, stay_time: 60, position: spots.count+1, lat: params[:lat], lng: params[:lng])
    if @spot.save
      render json: @spot.to_json
    else
      render json: { status: 'NG' }, status: :bad_request
    end
  end
end
