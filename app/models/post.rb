class Post < ApplicationRecord

  # Autocode: Relationships
  has_many :comments
  belongs_to :user

  # Autocode: Accept Nested Attributes

  # File Upload

  # Autocode: Validations
  validates_presence_of :title

  # Autocode: Callbacks

	# Soft Destroy

end
