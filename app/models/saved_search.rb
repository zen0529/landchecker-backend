class SavedSearch < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :filters, presence: true
end