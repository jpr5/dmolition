# Sandboxing our environment using submodules + symlinks so we can
# indiscriminately commit to them without having to re-run bundler or gems or
# whatever stupid shit other people do.

require 'rubygems'

# Manually add our load paths.  Whatever you symlink under vender gets used.
# For now we're symlinking against all the submodules.
ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
[ "/vendor/{gems/,}*/lib", "/lib" ].each do |path|
    $:.unshift *Dir[ROOT + path].map { |d| File.expand_path(d) }
end

# Defang RubyGems so we don't have to put silly version #'s on our vendor paths.
require 'gems'

# Now load our deps.
require 'active_support'
require 'data_objects'

require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

