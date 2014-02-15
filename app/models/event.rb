class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime

  has_one :location
  has_and_belongs_to_many :datasets
end