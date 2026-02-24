# frozen_string_literal: true

module CatFlac
  class Track
    attr_reader :album, :cover, :number, :title, :artist, :start_time, :duration, :genre

    def initialize(album:, number:, title:, artist:, start_time: nil, duration: nil, genre: nil, cover: nil)
      @album = album
      @cover = cover
      @number = number
      @title = title
      @artist = artist
      @start_time = start_time
      @duration = duration
      @genre = genre
    end

    def filename
      safe_title = title.gsub(%r{[/\\]}, "-")
      "#{number.to_s.rjust(2, '0')}. #{artist} - #{safe_title}"
    end
  end
end
