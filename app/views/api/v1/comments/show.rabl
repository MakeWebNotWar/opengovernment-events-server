object @comment => :comment
attributes :id, :text, :created_at, :updated_at

node :in_reply_to do
  root_object.in_reply_to
end

node :replies do
  root_object.replies
end

node :owner, :object_root => :owner do
  if root_object.owner
    root_object.owner.id
  else
    nil
  end
end