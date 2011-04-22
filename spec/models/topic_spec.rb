require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do

  describe 'organizes topics into hierarchies' do

    before :all do
      Blog.destroy_all
      @blog = Blog.make(:has_topics => true)
    end

    before :each do
      @blog.topics.destroy_all
      @parent_1 = @blog.topics.create!(Topic.make_unsaved.attributes.merge(:name => 'Stuff'))
      @parent_2 = @blog.topics.create!(Topic.make_unsaved.attributes.merge(:name => 'Things'))
      @child_1 = @blog.topics.create(Topic.make_unsaved.attributes.merge(:name => 'Breakable', :parent_id => @parent_1.id))
      @child_2 = @blog.topics.create(Topic.make_unsaved.attributes.merge(:name => 'Unbreakable', :parent_id => @parent_1.id))
      @child_3 = @blog.topics.create(Topic.make_unsaved.attributes.merge(:name => 'Plastic', :parent_id => @parent_2.id))
      @child_4 = @blog.topics.create(Topic.make_unsaved.attributes.merge(:name => 'Metal', :parent_id => @parent_2.id))
    end

    it 'returns its children' do
      @parent_1.children.to_a.should have(2).items
    end

    it 'returns its depth' do
      @parent_1.depth.should == 0
      @child_1.depth.should == 1
    end

    it 'lets a child grow up' do
      @child_4.move_to_root
      @child_4.root?.should be_true
    end

    it 'lets a parent relive its childhood' do
      @parent_2.move_to_child_of(@parent_1.id)
      @parent_2.parent.should == @parent_1
      @parent_2.depth.should == 1
      @parent_2.children.first.depth.should == 2
    end

    it 'deals with custody issues' do
      @child_3.move_to_child_of(@parent_1.id)
      @child_3.parent.should == @parent_1
    end

    it 'detects subtopics' do
      @blog.topics.new.has_subtopics?.should be_false
      @parent_1.has_subtopics?.should be_true
    end

    it 'returns its parent topic' do
      @child_1.parent.should == @parent_1
    end

    it 'returns its siblings' do
      @child_1.siblings.should include @child_2
      @child_1.siblings.should have(1).item
    end

    it 'detects roots' do
      @parent_1.root?.should be_true
      @child_1.root?.should be_false
    end

    it 'detects subtopics' do
      @parent_1.subtopic?.should be_false
      @child_1.subtopic?.should be_true
    end

    it 'returns its humanized path' do
      @parent_1.humanize_path.should == "/my-blog/stuff/"
      @child_1.humanize_path.should == "/my-blog/stuff/breakable/"
    end

  end

end
