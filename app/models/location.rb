class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, default: nil
  field :address_1, type: String, default: nil
  field :address_2, type: String, default: nil
  field :city, type: String, default: nil
  field :province, type: String, default: nil
  field :postal_code, type: String, default: nil
  field :country, type: String, default: "Canada"

  has_many :events
end