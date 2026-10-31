id="28aa9fb4-7a73-4ea3-8f46-cad72887151b"
pages=%w[find-your-council using-public-services].map{|slug| MainstreamBrowsePage.find_by!(slug:slug)}
pages.each do |p|
  list=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
  unless list.list_items.exists?(base_path:"/find-local-council")
    list.list_items.create!(base_path:"/find-local-council",title:"Find your local council",index:(list.list_items.maximum(:index)||0)+1)
  end
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>pages.map(&:content_id)})
pages.each{|p|ListPublisher.new(p).perform}
pages.map(&:parent).uniq.each{|p|TagBroadcaster.broadcast(p)}
puts "COUNCIL_FINDER_TAGGED #{pages.map(&:base_path).join(',')}"
