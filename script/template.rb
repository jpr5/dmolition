#!/usr/bin/ruby

require 'config/bootstrap'
require 'ruby-debug'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "mysql://root@localhost/foo")

class Foo
  include ::DataMapper::Resource

  property :id,         Serial
end

::DataMapper.auto_migrate!

# ...


debugger; 1

puts "done"


