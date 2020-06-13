# Delegates

[![Gem Version](https://badge.fury.io/rb/delegates.svg)](http://badge.fury.io/rb/delegates)
![build](https://github.com/zverok/delegates/workflows/CI/badge.svg)

This gem is just an extraction of the handy `delegate :method1, :method2, method3, to: :receiver` from ActiveSupport. It seems to be seriously superior to stdlib's [Forwardable](https://ruby-doc.org/stdlib-2.7.1/libdoc/forwardable/rdoc/Forwardable.html), and sometimes I want it in contexts when ActiveSupport and monkey-patching is undesireable.

Usage:

```
gem install delegates
```
(or add `gem 'delegates'` to your `Gemfile`).

Then:

```ruby
class Employee < Struct.new(:name, :department, :address)
  # ...
  extend Delegates
  delegate :city, :street, to: :address
  # ...
end

employee = Employee.new(name, department, address)

employee.city # will call employee.address.city
```

`to:` can be anything evaluatable from inside the class: `:<CONSTANT>`, `:@<instance_variable>`, `'chain.of.calls'` etc.; special names requiring `self` (like `class` method) handled gracefully with just `delegate ..., to: :class`. New methods are defined with `eval`-ing strings, so they are as fast as if manually written.

Supported options examples (all that ActiveSupport's `Module#delegate` supports):

```ruby
delegate :city, to: :address, prefix: true # defined method would be address_city
delegate :city, to: :address, prefix: :adrs # defined method would be adrs_city

delegate :city, to: :address, private: true # defined method would be private

delegate :city, to: :address, allow_nil: true
```
The latter option will handle the `employee.city` call when `employee.address` is `nil` by returning `nil`; otherwise (by default) informative `DelegationError` is raised.

## Credits

99.99% of credits should go to Rails users and contributors, who found and and handled miriads of realistic edge cases. I just copied the code (and groomed it a bit for closer to my own style).
