class User < ApplicationRecord
  has_secure_password

  has_many :watchlist_items, dependent: :destroy
  has_many :watched_properties, through: :watchlist_items, source: :property
  has_many :saved_searches, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end