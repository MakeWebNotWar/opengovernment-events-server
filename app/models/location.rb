class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :address_1, type: String
  field :address_2, type: String
  field :city, type: String
  field :province, type: String
  field :postal_code, type: String
  field :country, type: String, default: "Canada"

  belongs_to :event
  embeds_many :datasets
end