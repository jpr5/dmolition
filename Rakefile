task :default do
    Kernel.exec("#{$0}", '-T')
end

begin
    require 'rake/extensiontask'
rescue LoadError
else
    desc "Compile any native gems"
    task :compile
end

# Walk symlinks as well as normal directories.  Don't ask, just read:
# http://groups.google.com/group/ruby-talk-google/browse_thread/thread/e319f62f55cdea31
Dir["vendor/{**/*/**,}/*/ext/*"].each do |dir|
    next unless File.directory?(dir)
    FileList["#{dir}/**/extconf.rb"].each do |file|
        Rake::ExtensionTask.new do |t|
            t.name    = File.basename(dir)
            t.ext_dir = File.dirname(file)
            t.lib_dir = File.expand_path(dir + "/../../lib/#{t.name}")
            t.tmp_dir = '/tmp/rake-build.' + Process.pid.to_s
        end
    end
end
