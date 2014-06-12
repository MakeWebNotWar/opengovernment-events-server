object @comment => :ocomment
attributes :id, :text, :created_at, :updated_at

node :user, :object_root => :user do
  if root_object.user
    root_object.user.id
  else
    nil
  end
end

node :event, :object_root => :event do
  if root_object.event
    root_object.event.id
  else
    nil
  end
end

node :replies do
  if root_object.replies
    root_object.replies.map { |reply| reply.id }
  else
    nil
  end
end

node :parent_comment do
  if root_object.parent_comment
    root_object.parent_comment.id
  else
    nil
  end
end