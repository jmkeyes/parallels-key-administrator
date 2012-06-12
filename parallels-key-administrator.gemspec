# parallels-key-administrator.gemspec

Gem::Specification.new do |spec|
  spec.name        = 'parallels-key-administrator'
  spec.version     = '0.0.1'

  spec.authors     = ['Joshua Keyes']
  spec.email       = 'joshua.michael.keyes@gmail.com'

  spec.license     = 'MIT'
  spec.summary     = %q{Parallels' Key Administration API}
  spec.description = %q{Interface to Parallels' Key Administration API}

  spec.files       = Dir['lib/**/*.rb', 'bin/*', 'README.md']
  spec.executables << 'parallels-key-administrator'

  # TODO: GLI v1.6.7 doesn't include gli/app.rb for some reason. Consider using Trollop instead.
  spec.add_dependency 'gli', '>= 2.0.0.rc3'
end

#EOF
