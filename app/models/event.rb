class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String, default: "Untitled Event"
  field :description, type: String, default: "No Description."
  field :url, type: String, default: nil
  field :start_date, type: Date, default: DateTime.now.to_date
  field :start_time, type: Time, default: Time.now.strftime("%H:%M %z")
  field :end_date, type: Date, default: DateTime.now.to_date
  field :end_time, type: Time, default: (Time.now + 1.hour).strftime("%H:%M %z")
  field :type, type: String

  belongs_to :user
  belongs_to :location
  has_many :comments
  has_and_belongs_to_many :coorganizers, class_name: "User", inverse_of: "coorganizes"
  # has_many :comments, as: :commentable
  
  accepts_nested_attributes_for :location, inverse_of: nil

  validates_uniqueness_of :name

end