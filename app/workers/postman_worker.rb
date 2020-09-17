class PostmanWorker
    include Sidekiq::Worker
  
    def perform(h, count)
        h = JSON.load(h)

        if h['type'].eql?('welcome')
            ScheduleMailer.contact_email(h['name'], h['email'], h['message']).deliver_now
        else
                if h['type'].eql?('interview_create')
                    ScheduleMailer.interview_create(h['name'], h['email'], h['date'], h['start_time'], h['end_time']).deliver_now
                else
                    if h['type'].eql?('interview_update')
                        ScheduleMailer.interview_update(h['name'], h['email'], h['date'], h['start_time'], h['end_time']).deliver_now
                    else
                        ScheduleMailer.reminder(h['name'], h['email'], h['date'], h['start_time'], h['end_time'], h['message']).deliver_now
                    end
                end
        end
    end
end