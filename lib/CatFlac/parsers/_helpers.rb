module CatFlac
  module Parsers
    module Helpers
      module_function
      def read_cue_content(cue_path)
        File.read(cue_path, encoding: 'UTF-8')
      rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
        File.read(cue_path, encoding: 'Windows-1251').encode('UTF-8')
      end

      def get_audio_duration(path)
        require 'streamio-ffmpeg'
        duration = FFMPEG::Movie.new(path).duration
        Time.at(duration).utc.strftime("%M:%S:%L")
      rescue StandardError => e
        raise CatFlac::Error, "Failed to analyze audio file: #{e.message}"
      end

      def time_to_seconds(time)
        time_str = time.to_s
        return if time_str.empty?

        minutes, seconds, frames = time_str.split(':').map(&:to_i)

        (minutes * 60) + seconds + (frames / 75.0)
      end

      def find_cover(extensions, path)
        imgs = Dir.glob(File.join(path, "*.{#{extensions.join(',')}}"))
        return unless imgs.count == 1

        imgs.first
      end
    end
  end
end
