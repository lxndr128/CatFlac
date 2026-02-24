module CatFlac
  module Parsers
    class AIParser < Base
      ORDER = 3

      def self.match?(path)
        return false unless ENV['AI_API_KEY']

        Dir.glob(File.join(path, "*.{#{AUDIO_EXTENSIONS.join(',')}}")).any?
      end

      def initialize(path)
        formats = Dir.glob(File.join(path, "**/*.{#{AUDIO_EXTENSIONS.join(',')}}")).map do |path_|
          `ffprobe -v quiet -print_format json -show_format "#{path_}"`
        end.join("\n")

        files = Dir.glob(File.join(path, "*")).join("\n")

        @albums = AI::Request.make_request(files, formats)
      end

      def parse
        @albums.map { |album| Builders::AiAlbumBuilder.make_album(album) }
      end
    end
  end
end