Gem::Specification.new do |s|
    s.name          = 'bm-rpm-repo'
    s.version       = '0.0.1'
    s.date          = '2013-10-22'
    s.summary       = 'BM RPM Repo'
    s.description   = 'Buildmanagement RPM Repository'
    s.authors       = ['Kevin Viola Schmitz']
    s.email         = 'k.schmitz@tarent.de'
    s.homepage      = ''
    s.license       = 'WTFPL'
    s.files         = ['lib/bm-rpm-repo.rb', 'Rakefile']
    s.test_files    = Dir.glob('spec/*.rb')
    s.executables   << 'bm-rpm-repo'
    s.add_development_dependency 'rspec', '2.14'
end
