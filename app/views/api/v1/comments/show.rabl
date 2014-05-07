object @comment => :comment
attributes :id, :text, :created_at, :updated_at

node :owner, :object_root => :owner do
  if root_object.owner
    root_object.owner.id
  else
    nil
  end
end