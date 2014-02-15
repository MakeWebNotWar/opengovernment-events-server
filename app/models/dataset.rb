class Dataset
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, type: String
  field :description, type: String
  field :url, type: String

  has_and_belongs_to_many :events
end