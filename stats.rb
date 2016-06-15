require 'json'
require 'git'
# Stats: first commmit, ember version, embercli version
working_directory = File.expand_path(File.dirname(__FILE__))

global_stats = {}
Dir.glob(working_directory + "/repos/*").each do |project|
  stats = {
    "ember" => nil,
    "ember_cli" => nil,
    "first_commit" => nil,
    "ember_data" => nil,
    "auth" => nil
  }
  g = Git.open(project)
  begin
  first_commit = ""
  Dir.chdir(project) do
    first_commit = `git rev-list --max-parents=0 HEAD`
  end
  commit = g.gcommit first_commit.chomp.split(' ').first
  stats["first_commit"] = commit.date.strftime('%Y%m%d')
  rescue => e
    puts e
  end
  bower = nil
  begin
    f = File.read(project + "/bower.json")
    bower = JSON.parse(f)
    stats["ember"] = bower['dependencies']['ember']
  rescue => e
    puts e.message
  end
  package = nil
  begin
    f = File.read(project + "/package.json")
    package = JSON.parse(f)
    stats["ember_cli"] = package["devDependencies"]["ember-cli"]
  rescue => e
    puts e.message
  end
  # Ember data
  ember_data = nil
  begin
    if package
      ember_data = package["devDependencies"]["ember-data"]
    end
  rescue => e
    puts e.message
  end

  if bower && ember_data.nil?
    ember_data = bower["dependencies"]["ember-data"]
  end
  stats["ember_data"] = ember_data unless ember_data.nil?
  # auth lib
  auth = false
  if package
    auth = package.to_json.match(/simple-auth/)
  end
  if bower && !auth
    auth = bower.to_json.match(/simple-auth/)
  end
  stats["auth"] = auth
  global_stats[project.split('/').pop] = stats
end

File.open(working_directory + "/stats.json", 'w') do |f|
  f << JSON.pretty_generate(global_stats)
end
