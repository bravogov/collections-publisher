p = MainstreamBrowsePage.find_by!(slug:"using-public-services")
raise "Wrong parent" unless p.parent&.slug == "getting-started"
l = p.lists.find_by!(name:"Services")
item = l.list_items.find_by(base_path:"/contact/gov-uh")
if item
  item.destroy!
  ListPublisher.new(p).perform
  TagBroadcaster.broadcast(p.parent)
end
puts "UNSUPPORTED_BROWSE_ENTRY_CLEARED #{p.base_path}"
