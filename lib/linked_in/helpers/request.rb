module LinkedIn
  module Helpers

    module Request

      DEFAULT_HEADERS = {
        'x-li-format' => 'json'
      }

      API_PATH = '/v1'

      protected

        def get(path, options={})
          response = access_token.get("#{API_PATH}#{path}", headers: DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response.body
        rescue OAuth2::Error => e
          raise_errors(e.response)
        end

        def post(path, body='', options={})
          response = access_token.post("#{API_PATH}#{path}", body: body, headers: DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        rescue OAuth2::Error => e
          raise_errors(e.response)
        end

        def put(path, body, options={})
          response = access_token.put("#{API_PATH}#{path}", body: body, headers: DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        rescue OAuth2::Error => e
          raise_errors(e.response)
        end

        def delete(path, options={})
          response = access_token.delete("#{API_PATH}#{path}", headers: DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        rescue OAuth2::Error => e
          raise_errors(e.response)
        end

      private

        def raise_errors(response)
          # Even if the json answer contains the HTTP status code, LinkedIn also sets this status
          # in the HTTP answer (thankfully).
          data = Mash.from_json(response.body)

          case response.status.to_i
          when 401
            raise LinkedIn::Errors::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
          when 400
            raise LinkedIn::Errors::GeneralError.new(data), "(#{data.status}): #{data.message}"
          when 403
            raise LinkedIn::Errors::AccessDeniedError.new(data), "(#{data.status}): #{data.message}"
          when 404
            raise LinkedIn::Errors::NotFoundError.new(data), "(#{response.status}): #{data.message}"
          when 500
            raise LinkedIn::Errors::InformLinkedInError.new(data), "LinkedIn had an internal error. Please let them know in the forum. (#{response.status}): #{data.message}"
          when 502..503
            raise LinkedIn::Errors::UnavailableError.new(data), "(#{response.status}): #{data.message}"
          end
        end


        # Stolen from Rack::Util.build_query
        def to_query(params)
          params.map { |k, v|
            if v.class == Array
              to_query(v.map { |x| [k, x] })
            else
              v.nil? ? escape(k) : "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
            end
          }.join("&")
        end

        def to_uri(path, options)
          uri = URI.parse(path)

          if options && options != {}
            uri.query = to_query(options)
          end
          uri.to_s
        end
    end

  end
end
