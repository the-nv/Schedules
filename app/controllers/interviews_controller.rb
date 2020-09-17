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
        welcome
        interview_create_mail
        interview_reminder_mail
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

    if !(@interviewer.empty?)
        if @interviewer.update(interviewer_params)
            @interview.users << @interviewer
        else
            @interview.errors.add(:users, "invalid")
        end
    else
        @interview.users << User.new(interviewer_params)
    end

    logger.debug "DEBUG2 #{@currx.inspect}"

    logger.debug "DEBUG2 #{@interview.interviews_users.inspect}"
    # logger.debug "DEBUGGING #{@interview.interviews_users.inspect}"

    if !(@candidate.empty?)
        @candidate.update(candidate_params)
        @interview.users << @candidate
    else
        @interview.users << User.new(candidate_params)
    end

    logger.debug "DEBUG2 #{@curry.inspect}"

    logger.debug "DEBUG2 #{@interview.interviews_users.inspect}"

    respond_to do |format|
      if @interview.update(:interview_date => interview_params[:interview_date], :start_time => interview_params[:start_time], :end_time => interview_params[:end_time])
        interview_update_mail
        @entryx = @interview.interviews_users.where(:role => 0).first
        @entryx.destroy
        @currx = @interview.interviews_users.where(:role => nil).first
        @currx.update(:role => 0)

        @entryy = @interview.interviews_users.where(:role => 1).first
        @entryy.destroy
        @curry = @interview.interviews_users.where(:role => nil).first
        @curry.update(:role => 1)
        
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
        params.require(:interview).permit({interviews_users_attributes: [users: [:name, :email, :resume]]}, :interview_date, :start_time, :end_time)
    end

    def welcome
        candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

        h = JSON.generate({ 'type' => 'welcome', 
            'name' => candidate_params[:name],
            'email' => candidate_params[:email],
            'message' => "Welcome to interview scheduler!"})
    
        PostmanWorker.perform_async(h, 1)
    end

    def interview_create_mail
        candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

        h = JSON.generate({ 'type' => 'interview_create', 
            'name' => candidate_params[:name],
            'email' => candidate_params[:email],
            'date' => interview_params[:interview_date],
            'start_time' => interview_params[:start_time],
            'end_time' => interview_params[:end_time]})
    
        PostmanWorker.perform_async(h, 1)
    end

    def interview_update_mail
        candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

        h = JSON.generate({ 'type' => 'interview_update', 
            'name' => candidate_params[:name],
            'email' => candidate_params[:email],
            'date' => interview_params[:interview_date],
            'start_time' => interview_params[:start_time],
            'end_time' => interview_params[:end_time]})
    
        PostmanWorker.perform_async(h, 1)
    end

    def interview_reminder_mail
        candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

        h = JSON.generate({ 'type' => 'reminder', 
            'name' => candidate_params[:name],
            'email' => candidate_params[:email],
            'date' => interview_params[:interview_date],
            'start_time' => interview_params[:start_time],
            'end_time' => interview_params[:end_time],
            'message' => '30 min reminder'})

        date = interview_params[:interview_date]
        start_time = interview_params[:start_time]

        remind_at = date.to_time.to_i + start_time.to_i - 30 * 60

        logger.debug "DEBUGGERRRRR #{Time.at(remind_at)}"

        PostmanWorker.perform_at(remind_at, h, 1)
    end
end
