module CatFlac
  module Parsers
    class ChaptersParser < Base #TODO
    ORDER = 2
    # `ffprobe -v quiet -print_format json -show_format -show_streams -show_chapters "#{@audio_path}"`
      def self.match?(path)
        false
      end

    private
      def extract_embedded_chapters(file)
        cmd = `ffprobe -v quiet -print_format json -show_format -show_chapters \"#{file}\"`
        JSON.parse(cmd)
      end
    end
  end
end
