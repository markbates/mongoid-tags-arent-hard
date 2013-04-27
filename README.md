# Mongoid::TagsArentHard

A tagging gem for Mongoid 3 that doesn't actually suck.

For some reason all of the tagging gems for Mongoid suck. Not sure why, it's really not that hard a problem to solve. One of the biggest complaints I have is that you can't have a model that has two types of "tags". The other problem I have with the other gems is that I want to be able to set my tags equal to a string and have it become an Array, and vice versa. This gem solves both of those problems.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-tags-arent-hard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-tags-arent-hard

## Usage

To add tags to a model you need to first include the `Mongoid::TagsArentHard` module and then define what you want the field to be called using the `taggable_with` method.

```ruby
class Foo
  include Mongoid::Document
  include Mongoid::TagsArentHard

  taggable_with :tags
  taggable_with :colors, separator: ";"
end
```

Now we have two different types of "tags"; the first being called `tags` and the second being called `colors`. We have also told the `colors` to use `";"` as its separator.

Now we can do fun things like this:

```ruby
# set with either a string or an array:
foo = Foo.new(tags: "a,b,c", colors: ["red", "blue"])

# retrieve the list:
foo.tags #=> ["a", "b", "c"]
foo.colors #=> ["red", "blue"]

# append with either a string or an array:
foo.tags << "d,e"
foo.tags #=> ["a", "b", "c", "d", "e"]
foo.colors << ["green", "yellow"]
foo.colors #=> ["red", "blue", "green", "yellow"]

# set with either a string or an array:
foo.tags = ["x", "y", "z"]
foo.tags #=> ["x", "y", "z"]
foo.colors = "black;brown"
foo.colors #=> ["black", "brown"]
```

### Searching

There are a few scopes included that make it easy to find objects that have the tags you are looking for. These methods are generated using the name of the field you designed, so in our previous example we would have the following methods available to us:

```ruby
# Find objects with any of the values:
Foo.with_any_tags("a")
Foo.with_any_tags(["a", "b"])
Foo.with_any_tags("a, b")
Foo.with_any_colors("a")
Foo.with_any_colors(["a", "b"])
Foo.with_any_colors("a, b")

# Find objects with all of these values:
Foo.with_all_tags("a")
Foo.with_all_tags(["a", "b"])
Foo.with_all_tags("a, b")
Foo.with_all_colors("a")
Foo.with_all_colors(["a", "b"])
Foo.with_all_colors("a, b")

# Find objects without any of the values:
Foo.without_any_tags("a")
Foo.without_any_tags(["a", "b"])
Foo.without_any_tags("a, b")
Foo.without_any_colors("a")
Foo.without_any_colors(["a", "b"])
Foo.without_any_colors("a, b")

# Retrieve a distinct array of all tags
Foo.all_tags
Foo.where(name: 'test').all_tags
```

Again, notice that you can use either a string, an array, or a splatted list as values to these scopes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Contributers

* Mark Bates
* Carsten Block
* Luke Bergen
* Laurent Arnoud
* thomas morgan