class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :text, type: String

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :replies, class_name: "Comment", inverse_of: "parent_comment"
  belongs_to :parent_comment, class_name: "Comment", inverse_of: "replies"

  def in_reply_to
    if commentable
      parent_object = commentable
    elsif parent_comment
      parent_object = parent_comment
    else
      parent_object = nil
    end

    return {
      type: parent_object.class.to_s.downcase,
      id: parent_object.id.to_s
    } if parent_object
  end

  def owner
    return user if user
  end

end