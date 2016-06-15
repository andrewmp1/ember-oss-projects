require 'gruff'
require 'json'

# Create graphs for presentation
# Ember V Bar & Scatter plot
# Ember D Bar & Scatter plot
# First Commit XY Plot
#

working_directory = File.expand_path(File.dirname(__FILE__))
f = File.read(working_directory + "/stats.json")
stats = JSON.parse(f)
ember = {}
embercli = {}
simple_auth_count = 0
first_commits = []
versions = stats.each_pair do |k,v|
  version = v["ember"].to_s.match(/^\d+\.\d+/).to_s.to_f
  count = ember[version].to_i + 1
  ember[version] = count
  cli_version = v["ember_cli"].to_s.match(/^\d+\.\d+/).to_s.to_f
  unless cli_version == 0.0
    count = embercli[cli_version].to_i + 1
    embercli[cli_version] = count
  end
  simple_auth_count += 1 if !v["auth"].nil?
end

not_using = stats.keys.count - embercli.keys.count
embercli[0] = not_using
# Ember Pie Chart
g = Gruff::Pie.new(400)
g.theme = Gruff::Themes::PASTEL
g.title = "Ember Pie Chart"
ember.sort.each{ |k| g.data(k[0], [k[1]]) }
g.write("graphs/ember_version_pie.png")

# Ember Bar Chart
g = Gruff::Bar.new(400)
g.theme = Gruff::Themes::RAILS_KEYNOTE
g.title = "Ember Versions"
ember.sort.each{ |k| g.data(k[0], [k[1]]) }
g.minimum_value = 0
g.write("graphs/ember_version_bar.png")

# EmberCLI Pie Chart
g = Gruff::Pie.new(400)
g.theme = Gruff::Themes::PASTEL
g.title = "EmberCLI Pie Chart"
embercli.sort.each{ |k| g.data(k[0], [k[1]]) }
g.write("graphs/ember_cli_pie.png")

# EmberCLI Bar Chart
g = Gruff::Bar.new(400)
g.theme = Gruff::Themes::PASTEL
g.title = "EmberCLI Bar Chart"
embercli.sort.each{ |k| g.data(k[0], [k[1]]) }
g.minimum_value = 0
g.write("graphs/ember_cli_bar.png")

# SimpleAuth Pie Chart
g = Gruff::Pie.new(400)
g.theme = Gruff::Themes::PASTEL
g.title = "Simple Auth Usage"
g.data("Using", simple_auth_count)
g.data("Not Using", stats.keys.count - simple_auth_count)
g.write("graphs/ember_auth_pie.png")
