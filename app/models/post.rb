class Post < ApplicationRecord

  # Autocode: Relationships
  has_many :comments
  belongs_to :user

  # Autocode: Accept Nested Attributes

  # File Upload

  # Autocode: Validations

  # Autocode: Callbacks

	# Soft Destroy

end
