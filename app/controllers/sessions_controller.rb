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
      format.html
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
  def find_or_create_spot(name)
    spot = Spot.find_by_name(name)
    return spot.nil? ? Spot.create(name: name) : spot
  end

  def handle_html_create
    spot_id = session_params[:spot_id]

    # a given spotname overrides selected spot
    unless params["spotname"].blank?
      spot_id = find_or_create_spot(params["spotname"]).id
    end

    @session = find_session(current_user.id, spot_id)
    unless @session.nil?
      redirect_to sessions_url, alert: "Session existiert schon"
      return
    end

    @session = Session.new(session_params)
    @session.spot_id = spot_id
    @session.user = current_user
    if @session.save
      redirect_to sessions_url, notice: "Session erfolgreich veröffentlicht"
    else
      redirect_to sessions_url, alert:  "Spot wählen oder eingeben"
    end
  end

  def handle_json_create
    @session = find_session(@user.id, session_params[:spot_id])
    if @session.nil?
      @session = Session.new(session_params)
      @session.user = @user
      @session.save!
    end

    track = Track.create(session_id: @session.id,
                         user_id: @user.id,
                         duration: session_params[:duration],
                         distance: session_params[:distance],
                         maxspeed: session_params[:maxspeed],
                         tracked_at: session_params[:when]
    )
    if track.save
      render :show, status: :created, location: @session
    else
      format.json { render json: track.errors, status: :unprocessable_entity }
    end
  end

  def create
    respond_to do |format|
      format.html {
        handle_html_create
      }
      format.json {
        handle_json_create
      }
    end
  end

  def find_session(user_id, spot_id)
    date = session_params[:when].to_date
    Session.where(["spot_id = ? AND \"when\" = ? and user_id = ? and sport = ?", spot_id, date, user_id, session_params[:sport]]).order(when: :desc).first
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
