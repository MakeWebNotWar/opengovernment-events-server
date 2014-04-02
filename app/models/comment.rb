class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :text, type: String

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :event

  # validates_associated :parent, :children

end