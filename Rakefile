task :default do
    Kernel.exec("#{$0}", '-T')
end

##
## Submodules/remotes.
##
desc "List all remotes for submodules"
task 'remotes' do
    Dir["gems/*"].each do |dir|
        Dir.chdir(dir) do
            puts "#{dir}:"
            puts `git remote -v show`
        end
    end
end

desc "Initialize/update submodules + set upstream remotes"
task 'remotes:setup' do
    `git submodule init`
    `git submodule update`

    # Setup upstreams (where origin is our own forked repo)
    {
        'dm-core.git'       => 'git://github.com/datamapper/dm-core.git',
        'dm-do-adapter.git' => 'git://github.com/datamapper/dm-do-adapter.git',
    }.each do |repo, target|
        Dir.chdir("gems/#{repo}") { `git remote add upstream #{target}` }
    end
end
task :setup => [ 'remotes:setup' ]

##
## Set up compilation for any native Gems.
##
begin
    require 'rake/extensiontask'
rescue LoadError
else
    desc "Compile any native gems"
    task :compile

    TMPDIR = case `uname -s`.chomp
        when 'Darwin' then '/private/tmp'
        when 'Linux'  then '/tmp'
    end

    # Walk symlinks as well as normal directories.  Don't ask, just read:
    # http://groups.google.com/group/ruby-talk-google/browse_thread/thread/e319f62f55cdea31
    Dir["vendor/{**/*/**/,}*/ext/*"].each do |dir|
        next unless File.directory?(dir)
        FileList["#{dir}/**/extconf.rb"].each do |file|
            Rake::ExtensionTask.new do |t|
                t.name    = File.basename(dir)
                t.ext_dir = File.dirname(file)
                t.lib_dir = File.expand_path(dir + "/../../lib/#{t.name}")
                t.tmp_dir = "#{TMPDIR}/rake-build.#{Process.pid.to_s}"
            end
        end
    end
end

##
## Invoke tests.
##

task :test

namespace :test do

    task :env do
        ENV['RUBY_ENV'] = ENV['RAILS_ENV'] = ENV['RACK_ENV'] = "test"
        ENV["ADAPTER"] ||= "mysql" # for DM

        require 'config/bootstrap'
    end

    begin
        require 'spec'
        require 'spec/rake/spectask'

        Spec::Rake::SpecTask.new(:spec) do |t|
            Rake::Task["test:env"].invoke

            t.pattern    = ENV['SPEC'] || 'spec/**/*_spec.rb'
            t.warning    = false
            t.rcov       = false
        end

        Rake::Task['test'].enhance(['test:spec'])
    rescue LoadError
    end if File.directory?("spec")

    begin
        require 'cucumber'
        require 'cucumber/rake/task'

        Cucumber::Rake::Task.new(:cukes => :env) do |t|
            options = []
            options += %w"spec --format pretty"
            options += %w"-r spec/step_definitions"
            options += %w"-r spec/support"

            options += [ "-t", ENV['TAGS'] ] if ENV['TAGS']
            options += [ "-n", ENV['NAME'] ] if ENV['NAME']

            t.libs         += $:    # Include our own vendor gem paths
            t.fork          = false # We've already loaded the required libs
            t.cucumber_opts = options
        end

        Rake::Task['test'].enhance(['test:cukes'])
    rescue LoadError
    end if File.directory?("spec/features")

end

