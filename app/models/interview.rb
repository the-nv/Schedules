class Interview < ApplicationRecord
    has_many :interviews_users
    has_many :users, through: :interviews_users
end
