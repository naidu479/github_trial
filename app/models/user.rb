class User < ActiveRecord::Base

# Include default devise modules. Others available are:
# :confirmable, :lockable, :timeoutable and :omniauthable
 
 devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable 

  # Autocode: Relationships
  
  has_many :authtokens, dependent: :destroy
  has_many :identities, dependent: :destroy

  # Autocode: Validations

  validates_presence_of   :email, if: :email_required?
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true

  validates_presence_of     :password_confirmation, if: :password_required?
  validates_confirmation_of :password_confirmation, if: :password_required?

	
  # Autocode: Callback

	# File Upload

	# Soft Destroy

	def password_required?
    return false if email.blank?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end

end
