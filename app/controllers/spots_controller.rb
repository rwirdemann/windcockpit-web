class SpotsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_spot, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new edit create update destroy ], :if => Proc.new {|c| c.request.format.html?}

  # GET /spots or /spots.json
  def index
    @spots = Spot.all
  end

  # GET /spots/1 or /spots/1.json
  def show
  end

  # GET /spots/new
  def new
    @spot = Spot.new
  end

  # GET /spots/1/edit
  def edit
  end

  # POST /spots or /spots.json
  def create
    if Spot.exists?(name: spot_params["name"])
      @spot = Spot.find_by_name(spot_params["name"])
      respond_to do |format|
        format.html { redirect_to spot_url(@spot), notice: "Spot already exists." }
        format.json { render :show, status: :no_content, location: @spot }
      end
      return
    end

    @spot = Spot.new(spot_params)
    respond_to do |format|
      if @spot.save
        format.html { redirect_to spot_url(@spot), notice: "Spot was successfully created." }
        format.json { render :show, status: :created, location: @spot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spots/1 or /spots/1.json
  def update
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to spot_url(@spot), notice: "Spot was successfully updated." }
        format.json { render :show, status: :ok, location: @spot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end
  ''
  # DELETE /spots/1 or /spots/1.json
  def destroy
    @spot.destroy

    respond_to do |format|
      format.html { redirect_to spots_url, notice: "Spot was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_spot
    @spot = Spot.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def spot_params
    params.require(:spot).permit(:name)
  end
end