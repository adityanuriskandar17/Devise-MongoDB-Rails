class User
  include Mongoid::Document  
  include Mongoid::Timestamps
  include Devise::Models::DatabaseAuthenticatable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  field :remember_created_at, type: Time
  field :jti, type: String

  has_many :customers
  has_many :insurance_products
  has_many :asuransis

  def self.primary_key
    '_id'
  end

  def self.revoke_jwt(_payload, user)
    user.update_attribute(:jti, generate_jti)
  end
end
