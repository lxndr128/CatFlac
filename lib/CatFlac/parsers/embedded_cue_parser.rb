# frozen_string_literal: true

require "English"
module CatFlac
  module Parsers
    class EmbeddedCueParser < CueParser
      ORDER = 1

      def self.match?(path)
        return false unless Dir.glob(File.join(path, "*.cue")).none?

        files = Dir.glob(File.join(path, "*.{#{AUDIO_EXTENSIONS.join(',')}}"))
        return false unless files.one?

        extract_embedded_cuesheet(files.last).present?
      end

      def initialize(path)
        @audio_path = Dir.glob(File.join(path, "*.{#{AUDIO_EXTENSIONS.join(',')}}")).first
        cue = self.class.extract_embedded_cuesheet(@audio_path)
        @cuesheet = ::RubyCue::Cuesheet.new(cue).tap(&:parse!)
      end

      def self.extract_embedded_cuesheet(file)
        cmd = "ffprobe -v quiet -print_format json -show_format \"#{file}\""
        output = `#{cmd}`

        raise CommandError, "Failed to run ffprobe: #{$CHILD_STATUS.exitstatus}" unless $CHILD_STATUS.success?

        tags = JSON.parse(output).dig("format", "tags") || {}
        tags[tags.keys.find { |k| k.upcase == "CUESHEET" }]
      rescue JSON::ParserError => e
        raise ParserError, "Failed to parse ffprobe output: #{e.message}"
      end
    end
  end
end
