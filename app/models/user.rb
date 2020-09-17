class User < ApplicationRecord
    has_many :interviews_users
    has_and_belongs_to_many :interviews, through: :interviews_users

    validates :name, presence: true
end
