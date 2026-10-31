p=MainstreamBrowsePage.find_by!(slug:"government-and-public-services")
path="/respond-to-a-government-consultation"
services=p.lists.find_by!(name:"Services")
guidance=p.lists.find_by!(name:"Guidance")
item=services.list_items.find_by(base_path:path)
if item
 item.destroy!
 unless guidance.list_items.exists?(base_path:path)
  guidance.list_items.create!(base_path:path,title:"Respond to a government consultation",index:(guidance.list_items.maximum(:index)||0)+1)
 end
 ListPublisher.new(p).perform
 TagBroadcaster.broadcast(p.parent)
end
puts "CONSULTATIONS_GUIDANCE_GROUP #{guidance.list_items.exists?(base_path:path)} #{services.list_items.exists?(base_path:path)}"
