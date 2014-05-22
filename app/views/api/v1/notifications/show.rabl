object @notification => :notification
attributes :id, :text, :read, :read_at

node :user do
  root_object.user_id
end