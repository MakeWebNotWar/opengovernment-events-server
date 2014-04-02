object @user => :user
attributes :id, :firstname, :lastname, :gravatarID

node :events do 
  root_object.events.map { |event| event.id }
end
