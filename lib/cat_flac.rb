# frozen_string_literal: true

Dir[File.join(__dir__, "CatFlac/**/*.rb")].sort.each { |file| require file }

module CatFlac
  class Error < StandardError; end
  class ParserError < Error; end
  class NoMatchingParserError < ParserError; end
  class APIError < Error; end
  class CommandError < Error; end

  # Meow-meow
  def self.cat!(path)
    albums = Parsers::Base.parse(target_folder_path: path)
    albums.each { |album| Splitter.split(album) }
  rescue NoMatchingParserError => e
    warn(e.message)
  rescue CommandError, APIError => e
    warn("External dependency failed: #{e.message}")
  rescue ParserError => e
    warn("Parsing failed: #{e.message}")
  end
end
