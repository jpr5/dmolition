#!/usr/bin/ruby

require 'config/bootstrap'
require 'ruby-debug'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "mysql://root@localhost/foo")

class User
  include ::DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :height,     Integer,  :lazy => true
  property :weight,     Integer,  :lazy => true
  property :created_at, DateTime, :lazy => true
  property :updated_at, DateTime, :lazy => true
end

::DataMapper.auto_migrate!

User.create(:name => "name1")

user = User.get(1)

puts user.created_at
puts user.updated_at
puts user.height
puts user.weight

puts "done"


