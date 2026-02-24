# frozen_string_literal: true

module CatFlac
  module Parsers
    module Builders
      module AiAlbumBuilder
        module_function

        def make_album(album_data)
          album = CatFlac::Album.new(
            title: album_data["title"],
            artist: album_data["artist"],
            source_file: album_data["source_file"],
            genre: album_data["genre"],
            cover: album_data["cover"],
            release_date: album_data["release_date"]
          )

          start_time = 0

          album_data["tracks"].each_with_index do |track_data, index|
            duration = Helpers.time_to_seconds(track_data["duration"])

            track = CatFlac::Track.new(
              album: album_data["title"],
              number: (track_data["number"] || (index + 1)).to_i,
              title: track_data["title"],
              artist: track_data["artist"],
              start_time: start_time,
              duration: duration,
              genre: album_data["genre"]
            )

            start_time += duration

            album.add_track(track)
          end

          album
        end
      end
    end
  end
end
