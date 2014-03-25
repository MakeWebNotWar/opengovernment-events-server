class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :name, type: String, default: nil
  field :address_1, type: String, default: nil
  field :address_2, type: String, default: nil
  field :city, type: String, default: nil
  field :province, type: String, default: nil
  field :postal_code, type: String, default: nil
  field :country, type: String, default: "Canada"
  field :coordinates, type: Array

  geocoded_by :full_address
  after_validation :geocode


  def full_address
      [address_1, address_2, city, province, country].compact.join(', ')
  end
end