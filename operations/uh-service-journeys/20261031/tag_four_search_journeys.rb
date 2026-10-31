require "json"
items=JSON.parse(<<~'JSON')
[["find-a-united-hampshire-government-organisation","Find a United Hampshire government organisation","b6331736-1703-4096-8909-92a0da5a98e3",["government-and-public-services","using-public-services"]],["find-a-united-hampshire-minister","Find a United Hampshire minister","c1bb7f37-d88a-44ed-aefc-30a4c2de7bd0",["government-and-public-services"]],["search-united-hampshire-legislation","Search United Hampshire legislation","e6668925-a5aa-4143-9ca1-858a5677df37",["government-and-public-services","courts-and-tribunals"]],["search-government-publications-and-guidance","Search government publications and guidance","16eb8f1f-7db6-4ddb-b1b0-a210cc0c42f0",["information-requests","using-public-services"]]]
JSON
items.each do |slug,title,id,topics|
  pages=topics.map{|s|MainstreamBrowsePage.find_by!(slug:s)}
  pages.each do |p|
    list=p.lists.find_by(name:"Services") || p.lists.create!(name:"Services",index:0)
    path="/#{slug}"
    unless list.list_items.exists?(base_path:path)
      list.list_items.create!(base_path:path,title:title,index:(list.list_items.maximum(:index)||0)+1)
    end
    ListPublisher.new(p).perform
  end
  Services.publishing_api.patch_links(id,links:{"mainstream_browse_pages"=>pages.map(&:content_id)})
  pages.map(&:parent).uniq.each{|root|TagBroadcaster.broadcast(root)}
  puts "TAGGED #{slug} #{pages.map(&:base_path).join(',')}"
end
