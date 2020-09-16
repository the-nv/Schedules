class InterviewSchedulesController < ApplicationController
  before_action :set_interview_schedule, only: [:show, :edit, :update, :destroy]

  # GET /interview_schedules
  # GET /interview_schedules.json
  def index
    @interview_schedules = InterviewSchedule.all
  end

  # GET /interview_schedules/1
  # GET /interview_schedules/1.json
  def show
  end

  # GET /interview_schedules/new
  def new
    @interview_schedule = InterviewSchedule.new
  end

  # GET /interview_schedules/1/edit
  def edit
  end

  # POST /interview_schedules
  # POST /interview_schedules.json
  def create
    @interviewer = User.new()
    @interviewer.name = interview_schedule_params[:interviewer_name]
    @interviewer.email = interview_schedule_params[:interviewer_email]
    @interviewer.role = 0

    @candidate = User.new()
    @candidate.name = interview_schedule_params[:candidate_name]
    @candidate.email = interview_schedule_params[:candidate_email]
    @candidate.role = 1

    @interview = Interview.new()
    @interview.interview_date = interview_schedule_params[:interview_date]
    @interview.start_time = interview_schedule_params[:start_time]
    @interview.end_time = interview_schedule_params[:end_time]

    respond_to do |format|
      if @interviewer.save && @candidate.save && @interview.save
        @interview_interviewer = InterviewsUser.new()
        @interview_candidate = InterviewsUser.new()

        @interview_interviewer.interview_id = @interview.id
        @interview_interviewer.user_id = @interviewer.id

        @interview_candidate.interview_id = @interview.id
        @interview_candidate.user_id = @candidate.id
        
        if @interview_interviewer.save && @interview_candidate.save
          format.html { redirect_to interview_schedules_path, notice: 'Interview schedule was successfully created.'}
          format.json { render :show, status: :created, location: @interview_schedule }
        end
      else
        format.html { render :new }
        format.json { render json: @interview_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interview_schedules/1
  # PATCH/PUT /interview_schedules/1.json
  def update
    respond_to do |format|
      if @interview_schedule.update(interview_schedule_params)
        format.html { redirect_to @interview_schedule, notice: 'Interview schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @interview_schedule }
      else
        format.html { render :edit }
        format.json { render json: @interview_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interview_schedules/1
  # DELETE /interview_schedules/1.json
  def destroy
    @interview_schedule.destroy
    respond_to do |format|
      format.html { redirect_to interview_schedules_url, notice: 'Interview schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview_schedule
      @interview_schedule = InterviewSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interview_schedule_params
      params.fetch(:interview_schedule, {})
    end
end
