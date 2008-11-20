require 'rubygems' rescue nil
require 'rake'
require 'spec/rake/spectask'

ROOT_DIR = File.expand_path(File.dirname(__FILE__))

task :default => :spec

desc "Run all specs in spec directory."
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', "\"#{ROOT_DIR}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc 'Measures test coverage'
  task :rcov  => [:clean] do
    opts = File.open("#{ROOT_DIR}/spec/rcov.opts").readlines.map {|l| l.strip}
    rcov = "rcov #{opts.join(' ')}"
    system("#{rcov} #{ROOT_DIR}/spec/*_spec.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end

task :clean do
    system("rm", "-fr", "#{ROOT_DIR}/coverage", "#{ROOT_DIR}/coverage.data")
end
