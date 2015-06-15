# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "thin-multiserver-test"
APP_VERSION = "0.2"
TRAVELING_RUBY_VERSION = "20150517-2.1.6"
THIN_VERSION = "1.6.3"
EVENTMACHINE_VERSION = "1.0.6"

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install,
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz",
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz",      
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-thin-#{THIN_VERSION}.tar.gz"
    ] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install,
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz",      
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-thin-#{THIN_VERSION}.tar.gz"
    ] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install,
    "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz",
    "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz",    
    "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-thin-#{THIN_VERSION}.tar.gz"
  ] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.1\./
      abort "You can only 'bundle install' using Ruby 2.1, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -f packaging/vendor/*/*/cache/*"
    sh "rm -rf packaging/vendor/ruby/*/extensions"
    sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  end
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-thin-#{THIN_VERSION}.tar.gz" do
  download_native_extension("linux-x86", "thin-#{THIN_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-thin-#{THIN_VERSION}.tar.gz" do
  download_native_extension("linux-x86_64", "thin-#{THIN_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-thin-#{THIN_VERSION}.tar.gz" do
  download_native_extension("osx", "thin-#{THIN_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz" do
  download_native_extension("linux-x86", "eventmachine-#{EVENTMACHINE_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz" do
  download_native_extension("linux-x86_64", "eventmachine-#{EVENTMACHINE_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz" do
  download_native_extension("osx", "eventmachine-#{EVENTMACHINE_VERSION}")
end


def create_package(target)
  package_dir = "#{PACKAGE_NAME}-#{APP_VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "mkdir -p #{package_dir}/tmp/pids"
  sh "mkdir -p #{package_dir}/logs"
  #sh "cp hello.rb #{package_dir}/lib/app/"
  sh "cp config.ru thin.yml tr_thin.yml #{package_dir}/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/app.sh #{package_dir}/app"
  sh "chmod +x #{package_dir}/app"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-eventmachine-#{EVENTMACHINE_VERSION}.tar.gz " +
    "-C #{package_dir}/lib/vendor/ruby"  
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-thin-#{THIN_VERSION}.tar.gz " +
    "-C #{package_dir}/lib/vendor/ruby"
  if !ENV['DIR_ONLY']
    sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "cd packaging && curl -L -O --fail " +
    "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def download_native_extension(target, gem_name_and_version)
  sh "curl -L --fail -o packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz " +
    "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{target}/#{gem_name_and_version}.tar.gz"
end