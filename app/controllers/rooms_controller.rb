class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  def index
    @rooms = current_user.rooms
  end

  def show
    @photos = @room.photos
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    return render :new unless @room.save

    insert_images_to_room if params[:images]
    @photos = @room.photos
    redirect_to edit_room_path(@room), notice: "Saved..."
  end

  def edit
    return redirect_to root_path, notice: "You don't have permission." unless current_user.id == @room.user.id
    @photos = @room.photos
  end

  def update
    return render :edit unless @room.update(room_params)

    insert_images_to_room if params[:images]
    redirect_to edit_room_path(@room), notice: "Updated..."
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def insert_images_to_room
    params[:images].each { |image| @room.photos.create(image: image) }
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type,
      :accommodate, :bed_room, :bath_room,
      :listing_name, :summary, :address, :is_tv,
      :is_kitchen, :is_air, :is_heating, :is_internet,
      :price, :active, :images)
  end
end
