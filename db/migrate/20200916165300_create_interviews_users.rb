class CreateInterviewsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews_users do |t|
      t.integer :interview_id
      t.integer :user_id

      t.timestamps
    end
  end
end
