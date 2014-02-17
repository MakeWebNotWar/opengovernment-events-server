class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  field :name, type: String, default: nil
  field :description, type: String, default: nil
  field :url, type: String, default: nil
  field :start_date, type: DateTime, default: nil
  field :end_date, type: DateTime, default: nil


  belongs_to :location
  has_and_belongs_to_many :datasets

  accepts_nested_attributes_for :location, inverse_of: nil

end