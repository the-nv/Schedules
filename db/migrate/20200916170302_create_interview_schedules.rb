class CreateInterviewSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_schedules do |t|

      t.timestamps
    end
  end
end
