class Message < ApplicationRecord
  belongs_to :conversation
  
  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  
  scope :ordered, -> { order(created_at: :asc) }
end
