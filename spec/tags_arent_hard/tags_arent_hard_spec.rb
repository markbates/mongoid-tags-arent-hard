require 'spec_helper'

class Foo
  include Mongoid::Document
  include Mongoid::TagsArentHard

  field :label

  field :account, default: 'a'
  default_scope ->{ where(account: 'a') }

  taggable_with :tags
  taggable_with :colors, separator: ";"
end

describe Mongoid::TagsArentHard do

  let(:foo) { Foo.new }

  {tags: ",", colors: ";"}.each do |_name, _separator|

    describe ".taggable_with" do

      it "defines a getter for '#{_name}'" do
        foo.send(_name).should be_kind_of(Mongoid::TagsArentHard::Tags)
        foo.send(_name).should eql([])
      end

      it "defines a setter for '#{_name}' (string)" do
        foo.send("#{_name}=", "foo #{_separator} bar")
        foo.send(_name).should eql(["foo","bar"])
      end

      it "defines a setter for '#{_name}' (array)" do
        foo.send("#{_name}=", ["foo", "bar"])
        foo.send(_name).should eql(["foo","bar"])
      end

    end

    describe '#save' do

      it "saves the #{_name} correctly" do
        foo.send("#{_name}=", "foo#{_separator}bar")
        foo.save!
        foo.reload
        foo.send(_name).should eql(["foo","bar"])
      end

    end

    describe '+=' do

      it "adds and replaces using a string" do
        foo.send("#{_name}=", ["foo", "bar"])
        foo.send(_name).should eql(["foo","bar"])

        fooa = foo.send(_name)
        fooa += "a#{_separator}b"

        fooa.should eql(["foo","bar", "a", "b"])
      end

      it "adds and replaces using an array" do
        foo.send("#{_name}=", ["foo", "bar"])
        foo.send(_name).should eql(["foo","bar"])

        fooa = foo.send(_name)
        fooa += ["a", "b"]

        fooa.should eql(["foo","bar", "a", "b"])
      end

      it "adds and replaces using a Tags object" do
        foo.send("#{_name}=", ["foo", "bar"])
        foo.send(_name).should eql(["foo","bar"])

        fooa = foo.send(_name)
        fooa += Mongoid::TagsArentHard::Tags.new(["a", "b"], {})

        fooa.should eql(["foo","bar", "a", "b"])
      end

    end

    describe 'changes' do

      it "tracks changes correctly" do
        foo.save!
        foo.reload
        foo.send("#{_name}=", [])
        foo.send(_name) << ["foo", "bar"]
        changes = foo.changes
        changes[_name.to_s].should eql([[], ["foo", "bar"]])
      end

    end

    context "default scope" do
      before(:each) do
        @foo1 = Foo.create!(_name => "a#{_separator}b#{_separator}c", :account => 'b')
        @foo2 = Foo.create!(_name => "b#{_separator}c#{_separator}f", :account => 'a')
      end

      describe "all_#{_name}" do
        it "returns tags per account scope" do
          results = Foo.send("all_#{_name}")
          results.length.should be(3)
          results.should include 'b'
          results.should include 'c'
          results.should include 'f'
        end
      end
    end

    context 'class scopes' do

      before(:each) do
        @foo1 = Foo.create!(_name => "a#{_separator}b#{_separator}c", :label => 'test')
        @foo2 = Foo.create!(_name => "b#{_separator}c#{_separator}f")
        @foo3 = Foo.create!(_name => "d#{_separator}e#{_separator}f")
      end

      describe "all_#{_name}" do
        it "returns all unique tag names as an array" do
          results = Foo.send("all_#{_name}")
          results.length.should be(6)
          results.should include 'a'
          results.should include 'b'
          results.should include 'c'
          results.should include 'd'
          results.should include 'e'
          results.should include 'f'
        end

        it "returns all unique tag names within the given scope" do
          results = Foo.where(label: 'test').send("all_#{_name}")
          results.length.should be(3)
          results.should include 'a'
          results.should include 'b'
          results.should include 'c'
        end

      end

      describe "with_#{_name}" do

        it "returns all models with a specific #{_name} (splatted)" do
          results = Foo.send("with_#{_name}", "a")
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_#{_name}", "b")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)
        end

        it "returns all models with a specific #{_name} (arrayed)" do
          results = Foo.send("with_#{_name}", ["a"])
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_#{_name}", ["b"])
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)
        end

      end

      describe "with_any_#{_name}" do

        it "returns all models with any #{_name} (splatted)" do
          results = Foo.send("with_any_#{_name}", "a")
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_any_#{_name}", "b")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_any_#{_name}", "a", "e")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo3)
        end

        it "returns all models with any #{_name} (arrayed)" do
          results = Foo.send("with_any_#{_name}", ["a"])
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_any_#{_name}", ["b"])
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_any_#{_name}", ["a", "e"])
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo3)
        end

        it "returns all models with any #{_name} (string)" do
          results = Foo.send("with_any_#{_name}", "a")
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_any_#{_name}", "b")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_any_#{_name}", "a,e")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo3)
        end

      end

      describe "with_all_#{_name}" do

        it "returns all models with all #{_name} (splatted)" do
          results = Foo.send("with_all_#{_name}", "a")
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_all_#{_name}", "b")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_all_#{_name}", "a", "e")
          results.should have(0).foos

          results = Foo.send("with_all_#{_name}", "b", "f")
          results.should have(1).foo
          results.should include(@foo2)
        end

        it "returns all models with all #{_name} (arrayed)" do
          results = Foo.send("with_all_#{_name}", ["a"])
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_all_#{_name}", ["b"])
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_all_#{_name}", ["a", "e"])
          results.should have(0).foos

          results = Foo.send("with_all_#{_name}", ["b", "f"])
          results.should have(1).foo
          results.should include(@foo2)
        end

        it "returns all models with all #{_name} (string)" do
          results = Foo.send("with_all_#{_name}", "a")
          results.should have(1).foo
          results.should include(@foo1)

          results = Foo.send("with_all_#{_name}", "b")
          results.should have(2).foos
          results.should include(@foo1)
          results.should include(@foo2)

          results = Foo.send("with_all_#{_name}", "a,e")
          results.should have(0).foos

          results = Foo.send("with_all_#{_name}", "b,f")
          results.should have(1).foo
          results.should include(@foo2)
        end

      end

      describe "without_any_#{_name}" do

        it "returns all models without any #{_name} (splatted)" do
          results = Foo.send("without_any_#{_name}", "a")
          results.should_not have(1).foo
          results.should_not include(@foo1)

          results = Foo.send("without_any_#{_name}", "b")
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo2)

          results = Foo.send("without_any_#{_name}", "a", "e")
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo3)

          results = Foo.send("without_any_#{_name}", 'a', 'z')
          results.should have(2).foos
          results.should include(@foo2)
          results.should include(@foo3)

          results = Foo.send("without_any_#{_name}", 'z')
          results.should have(3).foos
          results.should include(@foo1)
          results.should include(@foo2)
          results.should include(@foo3)
        end

        it "returns all models without any #{_name} (arrayed)" do
          results = Foo.send("without_any_#{_name}", ["a"])
          results.should_not have(1).foo
          results.should_not include(@foo1)

          results = Foo.send("without_any_#{_name}", ["b"])
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo2)

          results = Foo.send("without_any_#{_name}", ["a", "e"])
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo3)

          results = Foo.send("without_any_#{_name}", ['a', 'z'])
          results.should have(2).foos
          results.should include(@foo2)
          results.should include(@foo3)

          results = Foo.send("without_any_#{_name}", ['z'])
          results.should have(3).foos
          results.should include(@foo1)
          results.should include(@foo2)
          results.should include(@foo3)
        end

        it "returns all models without any #{_name} (string)" do
          results = Foo.send("without_any_#{_name}", "a")
          results.should_not have(1).foo
          results.should_not include(@foo1)

          results = Foo.send("without_any_#{_name}", "b")
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo2)

          results = Foo.send("without_any_#{_name}", "a,e")
          results.should_not have(2).foos
          results.should_not include(@foo1)
          results.should_not include(@foo3)

          results = Foo.send("without_any_#{_name}", 'a,z')
          results.should have(2).foos
          results.should include(@foo2)
          results.should include(@foo3)

          results = Foo.send("without_any_#{_name}", 'z')
          results.should have(3).foos
          results.should include(@foo1)
          results.should include(@foo2)
          results.should include(@foo3)
        end

      end

    end

  end

end
