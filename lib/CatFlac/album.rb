module CatFlac
  class Album
    attr_reader :title, :artist, :year, :source_file, :tracks, :release_date, :cover

    def initialize(title:, artist:, source_file: nil, cover:, release_date:, genre:, tracks: [])
      @title = title
      @artist = artist
      @source_file = source_file
      @tracks = tracks
      @cover = cover
      @genre = genre
      @release_date = release_date
    end

    def add_track(track)
      @tracks << track
    end
  end
end
