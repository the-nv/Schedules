module Api
    module V1
        class InterviewsController < ApplicationController
            skip_before_action :verify_authenticity_token
            before_action :set_interview, only: [:show, :edit, :update]

            def index
                @interviews = Interview.all
            end

            def new
                @interview = Interview.new
                @interview.interviews_users.build(role: 0).build_user
                @interview.interviews_users.build(role: 1).build_user

                logger.debug "AAAAA #{@interview.users.last.inspect}"
            end

            def edit
            end

            def show
            end

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

                if @interview.save
                    render json: {status: "SUCCESS"}, status: :ok
                else
                    render json: {status: "FAILED"}, status: :unprocessable_entity
                end

              end

              def update
                interviewer_params = interview_params[:interviews_users_attributes]["0"][:users]
                candidate_params = interview_params[:interviews_users_attributes]["1"][:users]

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

                if !(@candidate.empty?)
                    @candidate.update(candidate_params)
                    @interview.users << @candidate
                else
                    @interview.users << User.new(candidate_params)
                end

                if @interview.update(:interview_date => interview_params[:interview_date], :start_time => interview_params[:start_time], :end_time => interview_params[:end_time])
                    @entryx = @interview.interviews_users.where(:role => 0).first
                    @entryx.destroy
                    @currx = @interview.interviews_users.where(:role => nil).first
                    @currx.update(:role => 0)

                    @entryy = @interview.interviews_users.where(:role => 1).first
                    @entryy.destroy
                    @curry = @interview.interviews_users.where(:role => nil).first
                    @curry.update(:role => 1)
                    
                    render json: {status: "SUCCESS"}, status: :ok
                else
                    render json: {status: "FAILED"}, status: :unprocessable_entity
                end
              end


            private
                def interview_params
                    params.require(:interview).permit({interviews_users_attributes: [users: [:name, :email, :resume]]}, :interview_date, :start_time, :end_time)
                end

                def set_interview
                    @interview = Interview.find(params[:id])

                    # render json: {status: 'SUCCESS', message: 'Loaded Interview', data:@interview}, status: :ok
                end
        end
    end
end