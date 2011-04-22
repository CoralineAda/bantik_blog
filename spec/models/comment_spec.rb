require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do

  it 'defaults to pending status' do
    Comment.new.state.should == "pending"
  end

  it 'transitions to approved' do
    comment = Comment.make
    comment.approve!
    comment.state.should == "approved"
  end

  it 'identifies itself as pending' do
    comment = Comment.make
    comment.pending?.should be_true
  end

end
