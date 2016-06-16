class Comment < ApplicationRecord

  # Autocode: Relationships
  belongs_to :user
  belongs_to :post

  # Autocode: Accept Nested Attributes

  # File Upload

  # Autocode: Validations
  validates_presence_of :text

  # Autocode: Callbacks

	# Soft Destroy

end
