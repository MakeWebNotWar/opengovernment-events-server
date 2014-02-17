object @location => :location
attributes :id, :name, :address_1, :address_2, :city, :province, :postal_code, :country

if root_object.events
  node :events do 
    root_object.events.map { |event| event.id }
  end
else
  node :events do
    nil
  end
end