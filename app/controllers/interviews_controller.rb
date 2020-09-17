class InterviewsController < ApplicationController
    before_action :set_interview, only: [:show, :edit, :update, :destroy]

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.all
    # logger.debug "DEBUGGING #{@interviews.first.interviews_users.where(:role => 0).first.user.email}.inspect"
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
  end

  # GET /interviews/new
  def new
    @interview = Interview.new
    @interview.interviews_users.build(role: 0).build_user
    @interview.interviews_users.build(role: 1).build_user

    logger.debug "AAAAA #{@interview.users.last.inspect}"
  end

  # GET /interviews/1/edit
  def edit
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(:interview_date => interview_params[:interview_date], :start_time => interview_params[:start_time], :end_time => interview_params[:end_time])

    interviewer_params = interview_params[:interviews_users_attributes]["0"][:users]
    candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

    # logger.debug "INSPECTING #{interviewer_params[:email].inspect}"

    @interviewer = User.where(:email => interviewer_params[:email])
    @candidate = User.where(:email => candidate_params[:email])

    if !(@interviewer.empty?)
        @interview.users << @interviewer.first
    else
        @interview.users << User.new(interviewer_params)
    end
    @interview.interviews_users.last.role = 0

    if !(@candidate.empty?)
        @interview.users << @candidate.first
    else
        @interview.users << User.new(candidate_params)
    end
    @interview.interviews_users.last.role = 1

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
    interviewer_params = interview_params[:interviews_users_attributes]["0"][:users]
    candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

    # logger.debug "INSPECTING #{interviewer_params[:email].inspect}"

    @interviewer = User.where(:email => interviewer_params[:email])
    @candidate = User.where(:email => candidate_params[:email])

    @entryx = @interview.interviews_users.where(:role => 0).first
    @entryx.destroy

    if !(@interviewer.empty?)
        @interviewer.update(interviewer_params)
        @interview.users << @interviewer
    else
        @interview.users << User.new(interviewer_params)
    end

    @currx = @interview.interviews_users.where(:role => nil).first

    logger.debug "DEBUG2 #{@currx.inspect}"
    @currx.update(:role => 0)

    logger.debug "DEBUG2 #{@interview.interviews_users.inspect}"
    # logger.debug "DEBUGGING #{@interview.interviews_users.inspect}"

    @entryy = @interview.interviews_users.where(:role => 1).first
    @entryy.destroy

    if !(@candidate.empty?)
        @candidate.update(candidate_params)
        @interview.users << @candidate
    else
        @interview.users << User.new(candidate_params)
    end

    @curry = @interview.interviews_users.where(:role => nil).first

    logger.debug "DEBUG2 #{@curry.inspect}"
    @curry.update(:role => 1)

    logger.debug "DEBUG2 #{@interview.interviews_users.inspect}"

    respond_to do |format|
      if @interview.update(:interview_date => interview_params[:interview_date], :start_time => interview_params[:start_time], :end_time => interview_params[:end_time])
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
    def set_interview
        @interview = Interview.find(params[:id])
    end

    def interview_params
        params.require(:interview).permit({interviews_users_attributes: [users: [:name, :email]]}, :interview_date, :start_time, :end_time)
    end
end
