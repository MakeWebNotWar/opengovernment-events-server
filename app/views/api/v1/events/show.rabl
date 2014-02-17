object @event => :event
attributes :id, :name, :description, :url, :start_date, :end_date

if root_object.location
  node :location, :object_root => :location do
    root_object.location.id
  end
else
  node :location, :object_root => :location do |l|
    nil
  end
end