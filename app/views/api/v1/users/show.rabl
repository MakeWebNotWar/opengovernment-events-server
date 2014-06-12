object @user => :user
attributes :id, :firstname, :lastname, :gravatarID, :confirmed

node :events do 
  if root_object.events
    root_object.events.map { |event| event.id }
  else
    []
  end
end

node :comments do
  if root_object.comments
    root_object.comments.map { |comment| comment.id }
  else
    []
  end
end

node :notifications do
  if root_object.notifications
    root_object.notifications.map { |notification| notification.id }
  else
    []
  end
end

node :organizes do
  if root_object.organizes
    root_object.organizes.map { |event| event.id }
  else
    []
  end
end

if current_user && current_user.id == root_object.id
  node :email do
    if root_object.email
      root_object.email
    else
      nil
    end
  end
end