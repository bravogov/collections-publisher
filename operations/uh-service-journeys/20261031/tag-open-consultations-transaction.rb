id="972a41c1-644d-47fd-b7d1-74e582bdaca7"
p=MainstreamBrowsePage.find_by!(slug:"government-and-public-services")
l=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
path="/find-an-open-government-consultation"
unless l.list_items.exists?(base_path:path)
 l.list_items.create!(base_path:path,title:"Find an open government consultation",index:(l.list_items.maximum(:index)||0)+1)
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>[p.content_id]})
ListPublisher.new(p).perform
TagBroadcaster.broadcast(p.parent)
puts "CONSULTATIONS_TRANSACTION_TAGGED #{p.base_path}"
