class InsuranceProduct
  include Mongoid::Document
  field :name, type: String

  belongs_to :user
  has_many :asuransis
end