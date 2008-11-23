Gem::manage_gems

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "method_lister"
    s.version   =   "0.1.0"
    s.author    =   "Matthew O'Connor"
    s.email     =   "matthew @nospam@ canonical.org"
    s.summary   =   "Pretty method listers and finders, for use in IRB."
    s.files     =   FileList['lib/*.rb', 'spec/*'].to_a
    s.require_path  =   "lib"
    s.autorequire   =   "method_lister"
    s.test_files = Dir.glob('spec/**/*_spec.rb')
    s.has_rdoc   =  true
    s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end