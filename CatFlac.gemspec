# frozen_string_literal: true

require_relative "lib/CatFlac/version"

Gem::Specification.new do |spec|
  spec.name = "CatFlac"
  spec.version = CatFlac::VERSION
  spec.authors = ["Aleksandr Akhtyrskii"]
  spec.email = ["alexakhtyrskii@gmail.com"]

  spec.summary = "A simple tool for splitting lossless audio files."
  spec.description = "CatFlac is an utility that helps you split large lossless audio files into tracks using CUE sheets or experimental AI identification. Still in early development."
  spec.homepage = "https://github.com/lxndr128/CatFlac"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lxndr128/CatFlac"
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata["changelog_uri"] = "https://github.com/lxndr128/CatFlac/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.match?(%r{\A(?:bin|test|spec|features|appveyor|Gemfile|Rakefile|sig/|\..*)|/spec/|\.gem\z|mock\.json})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "streamio-ffmpeg", "~> 3.0"
  spec.add_dependency "thor", "~> 1.3"
end
