object @comment => :comment
attributes :id, :text

node :event, :object_root => :event do
  root_object.event.id
end

node :user, :object_root => :user do
  if root_object.user
    root_object.user.id
  else
    nil
  end
end