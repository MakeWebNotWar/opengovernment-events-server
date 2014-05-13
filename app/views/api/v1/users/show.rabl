object @user => :user
attributes :id, :firstname, :lastname, :gravatarID

node :events do 
  if root_object.events
    root_object.events.map { |event| event.id }
  else
    []
  end
end
