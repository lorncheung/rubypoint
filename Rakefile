require 'rubygems'
require 'rspec'
require "rspec/core/rake_task" 
require 'bundler/gem_tasks'

require 'date'

autoload :RubyPoint, 'rubypoint'

desc "Run dhem speccczzz"
RSpec::Core::RakeTask.new(:core) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.spec_files = FileList['spec/**/*_spec.rb']
end
task :default => :spec

# RubyPoint specific

desc "Decompress a pptx into a folder in tmp/"
task :decompress, :file_path do |t, args|
  file_name = args.file_path.split('/').last
  puts "Decompressing #{args.file_path} into tmp/#{file_name}/"
  RubyPoint.open_doc(args.file_path, "tmp/#{file_name}")
end

desc "Recompress a folder into a pptx"
task :recompress, :folder_path, :save_path do |t, args|
  puts "Recompressing #{args.folder_path} into #{args.save_path}"
  RubyPoint.compress_folder(args.folder_path, args.save_path)
end

desc "Diff two pptxs using opendiff"
task :diff, :file1, :file2 do |t, args|
  puts "Diff of #{args.file1} and #{args.file2}"
  RubyPoint.diff(args.file1, args.file2)
end

desc "show two pptxs files"
task :show, :file1, :file2, :path do |t, args|
  puts "Showing #{args.file1} and #{args.file2}"
  puts RubyPoint.show(args.file1, args.file2, args.path)
end



