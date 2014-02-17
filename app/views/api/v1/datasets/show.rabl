object @dataset => :event
attributes :id, :name, :description, :url

node :events, :object_root => :events do
  if root_object.events
    root_object.events.map { |event| event.id }
  else
    nil
  end
end