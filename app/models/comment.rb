class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end