class EndpointsController < ApplicationController
  def index
    @endpoints = Endpoint.includes(:history_days, :status).order(created_at: :desc)
    @endpoint = Endpoint.new
  end

  def destroy
    endpoint = Endpoint.find(params[:id])
    endpoint.destroy
  end

  def create
    endpoint = Endpoint.new(endpoint_params)
    if endpoint.save
      puts 'saved'
    else
      puts 'failed'
    end
  end

  private

  def endpoint_params
    params.require(:endpoint).permit(:name, :url, :period, :max_response_time)
  end
end
