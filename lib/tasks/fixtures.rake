require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:environment => ENV['MERB_ENV'] || 'development')

desc "Load fixtures"
task :load_fixtures do

  DataMapper.auto_migrate! if Merb.orm == :datamapper
  files = ['users', 'tweets', 'groups', 'memberships', 'moderations', 'polls', 'poll_choices']

  files.each do |name|
    yml_file =  "/fixtures/#{name}.yml"
    puts "\nLoading: #{yml_file}"
    entries = YAML::load_file(Merb.root / yml_file)
    entries.each do |name, entry|
      n = name.sub(/\d+/,'')
      klass = Kernel::const_get(n.to_s.camel_case)
      k = klass::new(entry)
      puts "#{k} :#{name}"

      unless k.save
        puts "Validation errors saving a #{klass} (##{k.id}):"
        p k.errors
        raise
      end
    end
  end
end
