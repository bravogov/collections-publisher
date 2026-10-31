id="1cbf4889-acc3-4cb7-82b0-fd62679c4e0b"
p=MainstreamBrowsePage.find_by!(slug:"government-and-public-services")
l=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
path="/respond-to-a-government-consultation"
unless l.list_items.exists?(base_path:path)
 l.list_items.create!(base_path:path,title:"Respond to a government consultation",index:(l.list_items.maximum(:index)||0)+1)
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>[p.content_id]})
ListPublisher.new(p).perform
TagBroadcaster.broadcast(p.parent)
puts "CONSULTATION_START_TAGGED #{p.base_path} #{p.content_id}"
