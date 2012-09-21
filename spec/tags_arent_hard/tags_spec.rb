require "spec_helper"

describe Mongoid::TagsArentHard::Tags do
  
  let(:tags) { Mongoid::TagsArentHard::Tags.new(%w{foo bar baz}, {}) }

  after(:each) do
    Mongoid::TagsArentHard.config.separator = ","
  end

  describe 'initialize' do
    
    it "takes an array of tags" do
      tags = Mongoid::TagsArentHard::Tags.new(["foo", "bar"], {})
      tags.tag_list.should eql(["foo", "bar"])
    end

    it "takes a splatted list" do
      tags = Mongoid::TagsArentHard::Tags.new("foo", "bar", {})
      tags.tag_list.should eql(["foo", "bar"])
    end

    it "takes a string" do
      tags = Mongoid::TagsArentHard::Tags.new("foo,bar", {})
      tags.tag_list.should eql(["foo", "bar"])
    end

    it "takes a string with a different separator" do
      tags = Mongoid::TagsArentHard::Tags.new("foo bar", separator: " ")
      tags.tag_list.should eql(["foo", "bar"])
    end

  end

  describe 'to_s, to_str' do
    
    it "returns a comma separated list of tags" do
      tags.to_s.should eql("foo,bar,baz")
      tags.to_str.should eql("foo,bar,baz")
    end

  end

end