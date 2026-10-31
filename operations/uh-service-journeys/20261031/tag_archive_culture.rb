target = MainstreamBrowsePage.find_by!(slug:"museums-and-heritage")
raise "Wrong category" unless target.parent&.slug == "culture-and-recreation"
existing = MainstreamBrowsePage.find_by!(slug:"libraries-and-archives")
raise "Wrong existing placement" unless existing.parent&.slug == "local-services"
cid = "becfef73-f585-4f13-89aa-70205cfbec11"
list = target.lists.find_by(name:"Services") || target.lists.create!(name:"Services",index:0)
path = "/search-the-national-archives-catalogue"
unless list.list_items.exists?(base_path:path)
  list.list_items.create!(base_path:path,title:"Search the National Archives catalogue",index:(list.list_items.maximum(:index)||0)+1)
end
Services.publishing_api.patch_links(cid,links:{"mainstream_browse_pages"=>[existing.content_id,target.content_id]})
ListPublisher.new(target).perform
TagBroadcaster.broadcast(target.parent)
puts "ARCHIVES_TRANSACTION_TAGGED #{target.base_path} #{path}"
