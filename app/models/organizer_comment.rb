class OrganizerComment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :text, type: String

  belongs_to :user
  belongs_to :event
  has_many :organizer_replies, class_name: "OrganizerComment", inverse_of: "parent_comment", order: :created_at.asc
  belongs_to :parent_comment, class_name: "OrganizerComment", inverse_of: "organizer_replies"

end