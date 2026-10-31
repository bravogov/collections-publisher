root=MainstreamBrowsePage.only_level_one.find_by!(slug:"government-democracy-and-public-information")
child=MainstreamBrowsePage.find_by(slug:"public-information",parent_id:root.id)
unless child
 child=MainstreamBrowsePage.create!(parent:root,slug:"public-information",title:"Public information",description:"Practical public information, useful dates and ways to find official information.")
end
TagPublisher.new(child).publish if child.draft?
items=[
 ["when-do-the-clocks-change","When do the clocks change?","d8f7cac3-b8c9-4ccb-8379-435d6d83e656",[child.content_id]],
 ["search-government-publications-and-guidance","Search government publications and guidance","16eb8f1f-7db6-4ddb-b1b0-a210cc0c42f0",[
 MainstreamBrowsePage.find_by!(slug:"information-requests").content_id,
 MainstreamBrowsePage.find_by!(slug:"using-public-services").content_id,
 child.content_id]]
]
list=child.lists.find_by(name:"Services") || child.lists.create!(name:"Services",index:0)
items.each do |slug,title,id,tags|
 path="/#{slug}"
 unless list.list_items.exists?(base_path:path)
  list.list_items.create!(base_path:path,title:title,index:(list.list_items.maximum(:index)||0)+1)
 end
 Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>tags})
end
ListPublisher.new(child).perform
TagBroadcaster.broadcast(root)
puts "PUBLIC_INFORMATION_TOPIC_LIVE #{child.base_path} #{child.content_id}"
