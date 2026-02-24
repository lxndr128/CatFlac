module CatFlac
  module Parsers
    class Base
      AUDIO_EXTENSIONS = %w[
        flac wav ape wv m4a mp3 ogg opus tta tak aiff aif m4b
      ].freeze

      COVER_EXTENTIONS = %w[
        img jpg png jpeg
      ].freeze

      attr_reader :path
      def self.parse(target_folder_path:)
        @path = target_folder_path
        select_parser.new(target_folder_path).parse
      rescue ParserError
        raise
      rescue StandardError => e
        raise ParserError, "Unexpected error during parsing: #{e.message}"
      end

      def self.select_parser
        parsers = subclasses.sort_by { |klass| klass::ORDER }
        parsers.each do |parser_class|
          return parser_class if parser_class.match?(@path)
        end

        raise NoMatchingParserError, "No suitable parser found for path: #{@path}"
      end

      def self.match?
        raise NotImplementedError
      end
    end
  end
end