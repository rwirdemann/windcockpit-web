class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_session, only: %i[ show edit update destroy ]
  before_action :load_spots, only: %i[ new create index ]
  before_action :validate_apikey?, only: %i[ create ], :if => Proc.new { |c| c.request.format.json? }
  before_action :authenticate_user!, only: %i[ new edit create update destroy ], :if => Proc.new { |c| c.request.format.html? }

  # GET /sessions or /sessions.json
  def index
    if current_user.nil?
      @sessions = Session.all.order(when: :desc).where('visibility = ?', 'public')
    else
      @sessions = Session.all.order(when: :desc).where('visibility = ? OR user_id = ?', 'public', current_user.id)
    end
    @pagy, @sessions = pagy(@sessions)

    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
      format.json
    end
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
    session = creeate_or_find_session
    if session.nil?
      @session = Session.new(session_params)
      if request.format.html?
        @session.user = current_user
      else
        @session.user = @user
      end
    else
      @session = session
    end

    respond_to do |format|
      if @session.save
        format.html { redirect_to session_url(@session), notice: "Session was successfully created." }
        format.json {
          track = Track.create(session_id: @session.id,
                               user_id: @user.id,
                               duration: session_params[:duration],
                               distance: session_params[:distance],
                               maxspeed: session_params[:maxspeed],
                               tracked_at: session_params[:when],
          )
          if track.save
            render :show, status: :created, location: @session
          else
            format.json { render json: track.errors, status: :unprocessable_entity }
          end
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  def creeate_or_find_session
    date = session_params[:when].to_date
    Session.where(["spot_id = ? AND \"when\" = ? and user_id = ?", session_params[:spot_id], date, @user.id]).order(when: :desc).first
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
    params.require(:session).permit(:sport, :spot_id, :when, :duration, :distance, :maxspeed, :visibility)
  end

  def validate_apikey?
    apikey = request.headers["x-api-key"]
    return head(403) if apikey.blank?

    username = request.headers["username"]
    return head(403) if username.blank?

    @user = User.find_by_name(username)
    return head(403) if @user.nil?

    head(403) unless @user.authenticate_apikey(apikey)
  end
end
