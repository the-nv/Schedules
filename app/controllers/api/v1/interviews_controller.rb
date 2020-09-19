module Api
    module V1
        class InterviewsController < ApplicationController
            before_action :set_interview, only: [:show]

            def index
                interviews = Interview.all
                
                render json: {status: 'SUCCESS', message: 'Loaded Interviews', data:interviews}, status: :ok
            end

            def show
            end

            private
                def set_interview
                    interview = Interview.find(params[:id])

                    render json: {status: 'SUCCESS', message: 'Loaded Interview', data:interview}, status: :ok
                end
        end
    end
end