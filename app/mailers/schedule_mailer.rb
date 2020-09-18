class ScheduleMailer < ApplicationMailer
    def contact_email(name, email, message)
        @name = name
        @email = email
        @message = message

        mail(from: 'the.n.verma@gmail.com',
            to: @email,
            subject: 'Welcome!')
    end

    def interview_create(name, email, date, start_time, end_time)
        @name = name
        @email = email
        @date = date
        @start_time = start_time
        @end_time = end_time

        mail(from: 'the.n.verma@gmail.com',
            to: @email,
            subject: 'Interview Details!')
    end

    def interview_update(name, email, date, start_time, end_time)
        @name = name
        @email = email
        @date = date
        @start_time = start_time
        @end_time = end_time

        mail(from: 'the.n.verma@gmail.com',
            to: @email,
            subject: 'Interview Details!')
    end

    def reminder(name, email, date, start_time, end_time, message)
        @name = name
        @email = email
        @date = date
        @start_time = start_time
        @end_time = end_time
        @message = message

        mail(from: 'the.n.verma@gmail.com',
            to: @email,
            subject: 'Interview Reminder!')
    end
end
