require "spec_helper"

describe Mongoid::TagsArentHard::Tags do
  
  let(:tags) { Mongoid::TagsArentHard::Tags.new(%w{foo bar baz}, {}) }

  after(:each) do
    Mongoid::TagsArentHard.config.separator = ","
  end

  describe 'initialize' do
    
    it "takes an array of tags" do
      tags = Mongoid::TagsArentHard::Tags.new(["foo", "bar"], {})
      tags.should eql(["foo", "bar"])
    end

    it "takes a splatted list" do
      tags = Mongoid::TagsArentHard::Tags.new("foo", "bar", {})
      tags.should eql(["foo", "bar"])
    end

    it "takes a string" do
      tags = Mongoid::TagsArentHard::Tags.new("foo,bar", {})
      tags.should eql(["foo", "bar"])
    end

    it "takes a string with a different separator" do
      tags = Mongoid::TagsArentHard::Tags.new("foo bar", separator: " ")
      tags.should eql(["foo", "bar"])
    end

  end

  describe '<<' do
    
    it "takes a string" do
      tags << "fubar"
      tags.should eql(["foo", "bar", "baz", "fubar"])

      tags << "a,b"
      tags.should eql(["foo", "bar", "baz", "fubar", "a", "b"])
    end

    it "takes an array" do
      tags << ["a", "b"]
      tags.should eql(["foo", "bar", "baz", "a", "b"])
    end

    it "should not allow duplicates" do
      tags << "foo"
      tags.should eql(["foo", "bar", "baz"])
    end

  end

  describe '+' do
    
    it "adds the string to the list" do
      tags.should eql(["foo", "bar", "baz"])
      ntags = tags + "a,b"
      ntags.should eql(["foo", "bar", "baz", "a", "b"])
      puts "ntags.class.name: #{ntags.class.name}"
      ntags.should be_kind_of(Mongoid::TagsArentHard::Tags)
    end

    it "adds the array to the list" do
      tags.should eql(["foo", "bar", "baz"])
      ntags = tags + ["a", "b"]
      ntags.should eql(["foo", "bar", "baz", "a", "b"])
      ntags.should be_kind_of(Mongoid::TagsArentHard::Tags)
    end

    it "adds another Tag object" do
      tags.should eql(["foo", "bar", "baz"])
      ntags = tags + Mongoid::TagsArentHard::Tags.new(["a", "b"], {})
      ntags.should eql(["foo", "bar", "baz", "a", "b"])
      ntags.should be_kind_of(Mongoid::TagsArentHard::Tags)
    end

  end

  describe 'to_s, to_str' do
    
    it "returns a comma separated list of tags" do
      tags.to_s.should eql("foo,bar,baz")
      tags.to_str.should eql("foo,bar,baz")
    end

  end

  describe 'to_json' do
    
    it "returns an Array style json" do
      tags.to_json.should eql("[\"foo\",\"bar\",\"baz\"]")
    end

  end

  describe 'as_json' do
    
    it "returns the underlying array" do
      tags.as_json.should eql(["foo", "bar", "baz"])
    end

  end

end