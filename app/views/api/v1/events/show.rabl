object @event => :event
attributes :id, :name, :description, :url, :start_date, :start_time, :end_date, :created_at, :updated_at

node :location, :object_root => :location do
  if root_object.location
    root_object.location.id
  else
    nil
  end
end

node :comments do 
  if root_object.comments
    root_object.comments.map { |comment| comment.id }
  else
    []
  end
end

node :ocomments do 
  if root_object.organizer_comments
    root_object.organizer_comments.map { |comment| comment.id }
  else
    []
  end
end

node :organizers do
  if root_object.organizers
    root_object.organizers.map { |user| user.id }
  else
    []
  end
end

node :owner, :object_root => :owner do
  if root_object.owner
    root_object.owner.id
  else
    nil
  end
end