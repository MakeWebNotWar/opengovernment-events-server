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

node :email do
  if current_user && current_user.id == root_object.id
    if !root_object.email.empty?
      root_object.email
    elsif !root_object.unconfirmed_email.empty?
      root_object.unconfirmed_email
    else
      nil
    end
  else
    nil
  end
end