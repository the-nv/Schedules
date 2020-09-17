class Interview < ApplicationRecord
    has_many :interviews_users, inverse_of: :interview
    has_and_belongs_to_many :users, :through => :interviews_users
    accepts_nested_attributes_for :interviews_users

    validates :interview_date, presence: true
end
