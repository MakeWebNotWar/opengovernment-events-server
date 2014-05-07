class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String, default: "Untitled Event"
  field :description, type: String, default: "No Description."
  field :url, type: String, default: nil
  field :start_date, type: DateTime, default: Time.now
  field :end_date, type: DateTime, default: Time.now + 1.hour
  field :type, type: String

  belongs_to :user
  belongs_to :location
  has_many :comments
  # has_many :comments, as: :commentable
  
  accepts_nested_attributes_for :location, inverse_of: nil

  validates_uniqueness_of :name

end