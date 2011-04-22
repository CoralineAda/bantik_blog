xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@blog.title}"
    xml.description "Latest articles from #{@blog.title}"
    xml.link "#{@blog.feed_address}"

    @posts.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.summary
        xml.pubDate article.publication_date.to_s(:rfc822)
        @url = "#{request.protocol}#{request.host}#{":#{request.port}" if request.port}"
        xml.link "#{@url}#{article.full_path}"
        xml.guid "#{@url}#{article.full_path}"
      end
    end
  end
end