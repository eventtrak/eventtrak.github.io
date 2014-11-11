class EventsController < ApplicationController
  def index
    @events = Event.all
  end


  def new

  end

  def create
    @event = Event.create(event_params)
    redirect_to @event
  end

  def event_params
    params.require(:event).permit(:title, :body)
  end


  def show
    @event = Event.find(params[:id])
  end


  def test
  end
end
