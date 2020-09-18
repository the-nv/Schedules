class AddRoleToInterviewsUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews_users, :role, :integer
  end
end
