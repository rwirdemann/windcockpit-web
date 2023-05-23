class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_session, only: %i[ show edit update destroy ]
  before_action :load_spots, only: %i[ new create ]
  before_action :validate_apikey?, only: %i[ create ], :if => Proc.new {|c| c.request.format.json?}
  before_action :authenticate_user!, only: %i[ new edit create update destroy ], :if => Proc.new {|c| c.request.format.html?}

  # GET /sessions or /sessions.json
  def index
    @sessions = Session.all.order(when: :desc)
  end

  # GET /sessions/1 or /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions or /sessions.json
  def create
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to session_url(@session), notice: "Session was successfully created." }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1 or /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to session_url(@session), notice: "Session was successfully updated." }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def destroy
    @session.destroy

    respond_to do |format|
      format.html { redirect_to sessions_url, notice: "Session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = Session.find(params[:id])
    @spots = Spot.all
  end

  def load_spots
    @spots = Spot.all
  end

  # Only allow a list of trusted parameters through.
  def session_params
    params.require(:session).permit(:sport, :spot_id, :when, :duration, :distance, :maxspeed)
  end

  def validate_apikey?
    apikey = request.headers["x-api-key"]
    return head(403) if apikey.blank?

    username = request.headers["username"]
    return head(403) if username.blank?

    user = User.find_by_name(username)
    return head(403) if user.nil?

    head(403) unless user.authenticate_apikey(apikey)
  end
end
