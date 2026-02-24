require 'pry-byebug'

module CatFlac
  class Splitter
    def self.split(album)
      FileUtils.mkdir_p(album.title)
      ext = File.extname(album.source_file)

      album.tracks.each do |track|
        output_file = File.join(album.title, "#{track.filename + ext}")

        cmd = [
          "ffmpeg",
          "-y",
          "-i", album.source_file
        ]

        if album.cover
          cmd += ["-i", album.cover]
        end

        cmd += [
          "-ss", track.start_time.to_s,
          "-t", track.duration.to_s
        ]

        if album.cover
          cmd += ["-map", "0:a", "-map", "1:0"]
          cmd += ["-c:v", "mjpeg"]
          cmd += ["-disposition:v", "attached_pic"]
        else
          cmd += ["-map", "0:a"]
        end

        cmd += [
          "-metadata", "title=#{track.title}",
          "-metadata", "artist=#{track.artist}",
          "-metadata", "track=#{track.number}",
          "-metadata", "genre=#{track.genre}",
          "-metadata", "album=#{album.title}"
        ]

        cmd << output_file

        ok = system(*cmd)
        raise CommandError, "ffmpeg failed for #{output_file}" unless ok
      end
    end
  end
end