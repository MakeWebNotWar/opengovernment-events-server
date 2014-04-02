object @event => :event
attributes :id, :name, :description, :url, :start_date, :end_date

node :location, :object_root => :location do
  if root_object.location
    root_object.location.id
  else
    nil
  end
end

node :comments do 
  root_object.comments.map { |comment| comment.id }
end

node :users do 
  root_object.users.map { |user| user.id }
end
