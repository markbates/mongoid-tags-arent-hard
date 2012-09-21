require 'spec_helper'

class Foo
  include Mongoid::Document
  include Mongoid::TagsArentHard

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

      it "defines a setter for '#{_name}'" do
        foo.send("#{_name}=", "foo #{_separator} bar")
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

    context 'class scopes' do

      before(:each) do
        @foo1 = Foo.create!(_name => "a#{_separator}b#{_separator}c")
        @foo2 = Foo.create!(_name => "b#{_separator}c#{_separator}f")
        @foo3 = Foo.create!(_name => "d#{_separator}e#{_separator}f")
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

    end

  end

end