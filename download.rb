require 'git'
# clone all the projects in git
working_directory = File.expand_path(File.dirname(__FILE__))

# Download the repos.
DATA.each_line do |line|
  name,gitrepo = line.split(' ')
  next if name.nil? || gitrepo.nil?
  path = gitrepo.to_s.split('/').pop
  g = Git.clone(gitrepo, name.downcase, path: working_directory + "/repos")
end

__END__

Discourse https://github.com/discourse/discourse
Hummingbird https://github.com/hummingbird-me/hummingbird
Ghost https://github.com/TryGhost/Ghost
Balanced-Dashboard https://github.com/balanced/balanced-dashboard
Hospital-Run https://github.com/HospitalRun/hospitalrun-frontend
Ember-Observer https://github.com/emberobserver/client
Aptible	https://github.com/aptible/dashboard.aptible.com
Ember-Addons https://github.com/gcollazo/ember-cli-addon-search
HN-Reader	https://github.com/chancancode/hn-reader
Travis-CI	https://github.com/travis-ci/travis-web
Huboard	https://github.com/huboard/huboard-web
ShareDrop https://github.com/cowbell/sharedrop
Uhura	https://github.com/uhuraapp/uhura-frontend
Cargo	https://github.com/rust-lang/crates.io
Davros https://github.com/mnutt/davros
Wordset	https://github.com/wordset/wordset-ui
