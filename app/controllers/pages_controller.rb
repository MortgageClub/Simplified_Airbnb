class PagesController < ApplicationController
  def home
    @rooms = Room.all.limit(3)
  end

  def search
    assign_session
    assign_room_address

    @search = @rooms_address.ransack(params[:q])
    @rooms = @search.result

    @arr_rooms = @rooms.to_a
    check_room_not_available
  end

  private

  def assign_session
    session[:loc_search] = params[:search] if params[:search].present? && params[:search].strip != ""
  end

  def assign_room_address
    if session[:loc_search].present?
      @rooms_address = Room.where(active: true).near(session[:loc_search], 50, order: "distance")
    else
      @rooms_address = Room.where(active: true).all
    end
  end

  def check_room_not_available
    return unless params_valid?

    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    @rooms.each do |room|
      not_available = room.reservations.where(
        "(? <= start_date AND start_date <= ?)
        OR (? <= end_date AND end_date <= ?)
        OR (start_date < ? AND ? < end_date)",
        start_date, end_date,
        start_date, end_date,
        start_date, end_date
      ).limit(1)

      @arr_rooms.delete(room) if not_available.length > 0
    end
  end

  def params_valid?
    params[:start_date].present? && params[:end_date].present?
  end
end
