module ApplicationHelper
  include ScaffoldLogic::FormHelper
  include ScaffoldLogic::Helper
  include ScaffoldLogic::TabInterfaceHelper
  include ScaffoldLogic::MenuHelper
  include Helper

  def admin_breadcrumbs
    html = %{<ol class="breadcrumbs">}

    # Top-level
    html << content_tag(:li, link_to('Home', '/'))

    # Secondary

    # Tidy up
    html << %{</ol>}

    # Output that puppy.
    html.html_safe

  end

  def breadcrumbs
    unless controller?('home') && action?(/home|index/)
      html = [ link_to('Home', root_path) ]
#      html << link_to( 'Foo', foo_path ) if controller?('FoosController')
      (html * ' &gt; ').html_safe
    end
  end

  def select_tag_for_filter(model, nvpairs, params)
    options = { :query => params[:query] }
    _url = url_for(eval("admin_#{model}_url(options)"))
    _html = %{<label for="show">Show:</label><br />}
    _html << %{<select name="show" id="show"}
    _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}
    nvpairs.each do |pair|
      _html << %{<option value="#{pair[:scope]}"}
      if params[:show] == pair[:scope] || ((params[:show].nil? || params[:show].empty?) && pair[:scope] == "all")
        _html << %{ selected="selected"}
      end
      _html << %{>#{pair[:label]}}
      _html << %{</option>}
    end
    _html << %{</select>}
    _html.html_safe
  end

  def set_title(title = nil, window_title = nil)
    app_name ||= 'SEO Logic'
    window_title ||= title
    if title.nil?
      content_for(:title) { app_name }
      content_for(:page_title) {  }
    else
      content_for(:title) { window_title + " - #{app_name}" }
      content_for(:page_title) { title }
    end
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
