module Helper

  def sharing_links(post)
    _html = ""
    _html << link_to(image_tag('/images/icons/facebook.png', :class => :sharing_link), "http://www.facebook.com/sharer.php?u=#{CGI.escape(post.permalink)}", :target => "_blank")
    _html << link_to(image_tag('/images/icons/twitter.png', :class => :sharing_link), "http://twitter.com/home?status=#{CGI.escape(post.title)}:%20#{CGI.escape(post.permalink)}", :target => "_blank")
    _html.html_safe
  end

  def topics_for_select
    _topics = []
    Topic.roots.sort{|a,b| a.name <=> b.name}.each do |topic|
      _topics << [topic.name, topic.id]
      topic.children.each do |subtopic|
        _topics << ["- #{subtopic.name}", subtopic.id]
      end
    end
    _topics
  end

end