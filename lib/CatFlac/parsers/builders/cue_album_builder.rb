module CatFlac
  module Parsers
    module Builders
      module CueAlbumBuilder
        module_function
        def make_album(cuesheet, audio_path, path)
          album = CatFlac::Album.new(
            title: cuesheet.title,
            artist: cuesheet.performer,
            source_file: audio_path,
            genre: cuesheet.genre,
            cover: Helpers.find_cover(Base::COVER_EXTENTIONS, path),
            release_date: cuesheet.year
          )

          total_duration = Helpers.get_audio_duration(audio_path)

          cuesheet.songs.each_with_index do |song_data, index|
            start_time = Helpers.time_to_seconds(song_data[:index].to_s)
            next_song = cuesheet.songs[index + 1]
            end_time = Helpers.time_to_seconds(next_song&.[](:index) || total_duration)
            duration = end_time - start_time
            duration = 0 if duration < 0

            track = CatFlac::Track.new(
              album: album,
              number: (song_data[:track] || index + 1).to_i,
              title: song_data[:title],
              artist: song_data[:performer],
              start_time: start_time,
              duration: duration,
              genre: cuesheet.genre
            )

            album.add_track(track)
          end

          album
        end
      end
    end
  end
end
