class InterviewsUser < ApplicationRecord
    belongs_to :interviews
    belongs_to :users

    accepts_nested_attributes_for :users
    accepts_nested_attributes_for :interviews
end
