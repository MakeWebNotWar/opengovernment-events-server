object @comment => :comment
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