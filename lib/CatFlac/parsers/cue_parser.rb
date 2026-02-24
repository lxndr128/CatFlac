require_relative '../../../vendor/rubycue-master/lib/rubycue'

module CatFlac
  module Parsers
    class CueParser < Base
      ORDER = 0

      def self.match?(path)
        return false unless Dir.glob(File.join(path, "*.cue")).count == 1

        Dir.glob(File.join(path, "*.{#{AUDIO_EXTENSIONS.join(',')}}")).count == 1
      end

      def initialize(path)
        @path = path
        cue_path = Dir.glob(File.join(path, "*.cue")).first
        @audio_path = Dir.glob(File.join(path, "*.{#{AUDIO_EXTENSIONS.join(',')}}")).first
        begin
          @cuesheet = ::RubyCue::Cuesheet.new(Helpers.read_cue_content(cue_path)).tap {|c| c.parse! }
        rescue StandardError => e
          raise ParserError, "Failed to parse cuesheet #{cue_path}: #{e.message}"
        end
      end

      def parse
        [Builders::CueAlbumBuilder.make_album(@cuesheet, @audio_path, @path)]
      end
    end
  end
end