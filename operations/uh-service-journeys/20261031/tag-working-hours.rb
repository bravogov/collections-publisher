id="91ddbd17-077c-40df-9c95-1cc6ac3e4888"
pages=[
 MainstreamBrowsePage.find_by!(slug:"employment-rights"),
 MainstreamBrowsePage.find_by!(slug:"employment-support")
]
pages.each do |p|
 list=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
 path="/check-working-hours-and-breaks"
 unless list.list_items.exists?(base_path:path)
  list.list_items.create!(base_path:path,title:"Check working hours and rest breaks",index:(list.list_items.maximum(:index)||0)+1)
 end
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>pages.map(&:content_id)})
pages.each{|p|ListPublisher.new(p).perform}
pages.map(&:parent).uniq.each{|root|TagBroadcaster.broadcast(root)}
puts "HOURS_SERVICE_TAGGED #{pages.map(&:base_path).join(',')}"
