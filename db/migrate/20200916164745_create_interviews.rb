class CreateInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews do |t|
      t.date :interview_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
