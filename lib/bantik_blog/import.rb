# NOTE: search-and-replace content> with contents> before importing

module BantikBlog

  module Import

    class WordPress

      attr_accessor :source_file

      def initialize(file)
        self.source_file = file
      end

      def to(blog)
        self.posts.each do |post|
          blog.posts.create(
            :title => post.title,
            :author => blog.default_author,
            :publication_date => post.publication_date,
            :content => post.content,
            :summary => post.content.truncate(255),
            :state => "published",
            :desired_slug => "#{post.title.to_s}"
          )
        end
      end

      def posts
        @posts ||= []
        if @posts.empty?
          raw_posts.each do |item|
            @posts << Post.new(
              :title => item.xpath(".//title").first.content,
              :date => item.xpath(".//pubDate").first.content,
              :content => item.xpath(".//contents").children.first.content
            )
          end
        end
        @posts
      end

      def source
        @source ||= Nokogiri::XML(File.open(self.source_file))
      end

      def raw_posts
        self.source.xpath("//item")
      end

      class Post
        attr_accessor :title, :date, :content
        def initialize(args)
          args.each{|k,v| self.send("#{k}=",v) if self.respond_to?(k)}
        end
        def publication_date
          DateTime.parse(self.date)
        end
      end

    end

  end

end