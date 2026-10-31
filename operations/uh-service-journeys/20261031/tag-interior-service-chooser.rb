id="76c578fc-f784-44c9-9668-008df15e7541"
pages=[
 MainstreamBrowsePage.find_by!(slug:"citizenship-and-nationality"),
 MainstreamBrowsePage.find_by!(slug:"visas-and-entry")
]
pages.each do |p|
 list=p.lists.find_by(name:"Services")||p.lists.create!(name:"Services",index:0)
 unless list.list_items.exists?(base_path:"/check-citizenship-or-immigration-service")
  list.list_items.create!(base_path:"/check-citizenship-or-immigration-service",title:"Check which citizenship or immigration service to use",index:(list.list_items.maximum(:index)||0)+1)
 end
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>pages.map(&:content_id)})
pages.each{|p|ListPublisher.new(p).perform}
pages.map(&:parent).uniq.each{|r|TagBroadcaster.broadcast(r)}
puts "INTERIOR_SERVICE_CHOOSER_TAGGED #{pages.map(&:base_path).join(',')}"
