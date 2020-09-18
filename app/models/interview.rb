class Interview < ApplicationRecord
    has_many :interviews_users, inverse_of: :interview
    has_and_belongs_to_many :users, :through => :interviews_users
    accepts_nested_attributes_for :interviews_users

    validates :interview_date, presence: true  
    validates :start_time, presence: true
    validates :end_time, presence: true

    validate :end_after_start
    validate :conflicts

    private
        def end_after_start
            return if interview_date.blank? || start_time.blank? || end_time.blank?

            if end_time < start_time
                errors.add(:end_time, "must me after start time")
            end
        end

        def conflicts
            return if interview_date.blank? || start_time.blank? || end_time.blank?
            
            current_start = start_time.to_i + interview_date.to_time.to_i
            current_end = end_time.to_i + interview_date.to_time.to_i

            check_user = User.where(:email => users.first.email).first

            if check_user
                schedules = User.where(:id => check_user.id).first.interviews
                schedules.each do |schedule|
                    schedule_start = schedule.start_time.to_i + schedule.interview_date.to_time.to_i
                    schedule_end = schedule.end_time.to_i + schedule.interview_date.to_time.to_i

                    if (current_start >= schedule_start && current_start <= schedule_end) || ((current_end >= schedule_start && current_end <= schedule_end))
                        errors.add(:start_time, "conflicts " + schedule.id.to_s)
                    end
                end    
            end
        end
end
