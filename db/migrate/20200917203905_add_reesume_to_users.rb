class AddReesumeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_attachment :users, :resume
  end
end
