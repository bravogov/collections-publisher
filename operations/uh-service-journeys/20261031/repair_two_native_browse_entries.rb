[
  ["government-and-public-services","government-democracy-and-public-information","/express-interest-in-ministerial-service","Express an interest in ministerial service","1b8eb9e2-3896-4db3-95e4-9e52867b7fbf"],
  ["using-public-services","getting-started","/contact/gov-uh","Report a problem with GOV.UH",nil]
].each do |slug,root_slug,path,title,content_id|
  p = MainstreamBrowsePage.find_by!(slug:slug)
  raise "Wrong root for #{slug}" unless p.parent&.slug == root_slug
  list = p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
  unless list.list_items.exists?(base_path:path)
    list.list_items.create!(base_path:path,title:title,index:(list.list_items.maximum(:index)||0)+1)
  end
  Services.publishing_api.patch_links(content_id,links:{"mainstream_browse_pages"=>[p.content_id]}) if content_id
  ListPublisher.new(p).perform
  TagBroadcaster.broadcast(p.parent)
  puts "PUBLISHED_SERVICE_LINK #{p.base_path} #{path}"
end
