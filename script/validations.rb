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

debugger; 1

user.created_at = DateTime.now
# This also triggers two separate loads; probably maps to individual property assignment.
#user.update(:created_at => DateTime.now, :updated_at => DateTime.now)
user.save

puts "done"


