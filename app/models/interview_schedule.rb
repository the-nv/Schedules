class InterviewSchedule < ApplicationRecord
    belongs_to :interviews
    belongs_to :users
end
