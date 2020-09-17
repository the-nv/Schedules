class InterviewsController < ApplicationController
    before_action :set_interview, only: [:show, :edit, :update, :destroy]

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.all
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
  end

  # GET /interviews/new
  def new
    @interview = Interview.new
  end

  # GET /interviews/1/edit
  def edit
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(:interview_date => interview_params[:interview_date], :start_time => interview_params[:start_time], :end_time => interview_params[:end_time])

    @interviewer = User.where(:email => interview_params[:interviewer_email])
    @candidate = User.where(:email => interview_params[:candidate_email])

    if !(@interviewer.empty?)
        @interview.users << @interviewer.first
    else
        @interview.users << User.new(:name => interview_params[:interviewer_name], :email => interview_params[:interviewer_email], :role => 0)
    end

    if !(@candidate.empty?)
        @interview.users << @candidate.first
    else
        @interview.users << User.new(:name => interview_params[:candidate_name], :email => interview_params[:candidate_email], :role => 1)
    end

    respond_to do |format|
      if @interview.save
        format.html { redirect_to interviews_path, notice: 'Interview schedule was successfully created.'}
        format.json { render :show, status: :created, location: @interview }
      else
        format.html { render :new }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interviews/1
  # PATCH/PUT /interviews/1.json
  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to @interview, notice: 'Interview schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @interview }
      else
        format.html { render :edit }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview.destroy
    respond_to do |format|
      format.html { redirect_to interviews_url, notice: 'Interview schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview
d(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interview_params
      params.fetch(:interview, {})
    end
end
