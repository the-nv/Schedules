class User < ApplicationRecord
    has_many :interviews_users
    has_and_belongs_to_many :interviews, through: :interviews_users

    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

    has_attached_file :resume
    validates_attachment_content_type :resume,
        :content_type => ['application/pdf', 'application/msword', 'text/plain'], :if => :resume_attached?,
        presence: true

    def resume_attached?
        self.resume?
    end
end
