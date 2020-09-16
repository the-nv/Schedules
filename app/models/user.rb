class User < ApplicationRecord
    has_many :interviews_users
    has_many :interviews, through: :interviews_users
end
