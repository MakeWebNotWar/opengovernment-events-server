class Dataset
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name, type: String
  field :description, type: String
  field :url, type: String

  embedded_in :location
end