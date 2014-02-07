class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime

  has_one :location
  embeds_many :datasets
end