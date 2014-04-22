object @comment => :comment
attributes :id, :text, :created_at, :updated_at

node :in_reply_to do
  root_object.in_reply_to
end

node :replies do
  root_object.replies
end

node :user, :object_root => :user do
  if root_object.user
    root_object.user.id
  else
    nil
  end
end