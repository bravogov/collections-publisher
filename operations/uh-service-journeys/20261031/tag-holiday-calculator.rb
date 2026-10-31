id="72f4094a-1c16-4dd2-a6fc-3fa9f8f1292a"
pages=[MainstreamBrowsePage.find_by!(slug:"employment-rights"),MainstreamBrowsePage.find_by!(slug:"employment-support")]
pages.each do |p|
 l=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
 unless l.list_items.exists?(base_path:"/calculate-holiday-entitlement")
  l.list_items.create!(base_path:"/calculate-holiday-entitlement",title:"Calculate holiday entitlement",index:(l.list_items.maximum(:index)||0)+1)
 end
end
Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>pages.map(&:content_id)})
pages.each{|p|ListPublisher.new(p).perform}
pages.map(&:parent).uniq.each{|r|TagBroadcaster.broadcast(r)}
puts "HOLIDAY_TAGGED #{pages.map(&:base_path).join(',')}"
