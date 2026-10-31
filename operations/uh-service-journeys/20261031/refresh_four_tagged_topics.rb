pages=%w[government-and-public-services using-public-services courts-and-tribunals information-requests]
pages.each do |slug|
  p=MainstreamBrowsePage.find_by!(slug:slug)
  ListPublisher.new(p).perform
  TagBroadcaster.broadcast(p.parent)
  puts "REPUBLISHED_NATIVE_TOPIC #{p.base_path}"
end
