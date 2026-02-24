require 'json'
require 'net/http'

module CatFlac
  module Parsers
    module AI
      module Request
        PROMPT = <<-TEXT
          You are a music metadata expert. Use MusicBrainz or Discogs, and ONLY in case you can't find
          anything there use another sources.
          
          1. Identify the album or albums from these files
          2. Find the EXACT official tracklist with durations (MM:SS:FF format)
          3. Match files to tracks by order and duration
          4. Return accurate data from the database, not the files
          5. USE PROVIDED SCHEMA! STRICTLY. THERE IS COMPLETED DESCRIPTION OF DATA WHAT WE NEED IN THIS SCHEMA
          6. Check output json on syntax errors.
          7. Be carefull, some releases could be described as one big track, but still contain a few different tracks inside.
             We want to split it anyway, don't care about artistic obstacles
  
        TEXT

        RESPONSE_SCHEMA = {
          albums: [
            {
              source_file: { type: 'string', description: 'Relative path to the music file' },
              title: { type: 'string' },
              artist: { type: 'string' },
              cover: { type: 'string', description: 'Relative path to the cover file' },
              genre: { type: 'string' },
              release_date: { type: 'string' },
              tracks: [
                {
                  cover: { type: ['string', 'null'], description: 'Only in case of separate covers for each track' },
                  number: { type: 'string' },
                  title: { type: 'string' },
                  artist: { type: 'string' },
                  duration: { type: 'string (CUE format 75 frames)', format: "mm:ss:ff" },
                }
              ]
            }
          ]
        }

        module_function
        def make_request(files, formats)
          return JSON.parse(File.read('mock.json')) if File.exist?('mock.json')

          uri = URI('https://api.perplexity.ai/v1/responses')

          request = Net::HTTP::Post.new(uri)
          request['Authorization'] = "Bearer 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"
          request['Content-Type'] = 'application/json'

          request.body = body(files, formats).to_json

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: 300) do |https|
            https.request(request)
          end

          unless response.is_a?(Net::HTTPSuccess)
            raise APIError, "AI API request failed: #{response.code} #{response.message}"
          end

          text = JSON.parse(response.body).dig("output", -1, "content", -1, "text")
          JSON.parse(text)['albums']
        rescue JSON::ParserError => e
          raise ParserError, "Failed to parse AI response: #{e.message}"
        rescue Net::HTTPError, SocketError, Timeout::Error => e
          raise APIError, "Network error during AI request: #{e.message}"
        end

        def body(files, formats)
          content =  PROMPT + "\nFILES:\n" + files + "\nMETADATA:\n" + formats + "Respone shema" + RESPONSE_SCHEMA.to_json
          {
            input: [
              {
                type: "message",
                role: "system",
                content: content
              }
            ],
            instructions: "Use web_search to find exact metadata from MusicBrainz/Discogs. Never guess.",
            model: "perplexity/sonar",
            tools: [
              {
                type: "web_search",
                filters: {
                  search_domain_filter: ["musicbrainz.org", "discogs.com", "youtube.com"],
                }
              }
            ]
          }
        end
      end
    end
  end
end

#require_relative 'lib/CatFlac'
#CatFlac.cat!('test')