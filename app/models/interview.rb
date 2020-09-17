class Interview < ApplicationRecord
    has_many :interviews_users, foreign_key: "interview_id"
    has_and_belongs_to_many :users, :through => :interviews_users

    validates :interview_date, presence: true
end
