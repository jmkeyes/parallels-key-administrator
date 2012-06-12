# lib/parallels/key_administrator/response.rb

module Parallels #:nodoc: Already documented

  module KeyAdministrator #:nodoc: Already documented

    # = PKA::Response
    #
    # The response class for an XMLRPC request.
    class Response

      # Response codes as documented by Parallels' API Guide.
      RESPONSE_CODES = {

        # No result code given.
        0 => 'No response, or no response code given',

        # Successful results are in the 1xx range.
        100 => 'Success',
        101 => 'No results',

        # Business logic errors are in the 2xx range.
        200 => 'Authorization failed',
        201 => 'Method access denied',
        202 => 'Object access denied',
        251 => 'Login already exists',

        # Remote server errors are in the 3xx range.
        300 => 'Remote server internal error',

        # Bad request errors are in the 4xx range.
        400 => 'Invalid authorization format',
        401 => 'Invalid server format',
        431 => 'Invalid login format',
        432 => 'Invalid password format',
        433 => 'Invalid first name format',
        434 => 'Invalid last name format',
        435 => 'Invalid company format',
        436 => 'Invalid address format',
        437 => 'Invalid email format',
        438 => 'Invalid phone format',
        439 => 'Invalid fax format',
        440 => 'Invalid city format',
        441 => 'Invalid zip code format',
        442 => 'Invalid state format',
        443 => 'Invalid country format',
        444 => 'Invalid language format',
        447 => 'First name too long',
        448 => 'Last name too long',
        450 => 'Email too long',
        451 => 'No search parameters defined',

        # Deliberately invalid response code.
        999 => 'Invalid response code'
      }

      # Provide read-only public accessors for code, message, and data.
      attr_reader :code, :message, :data

      # Build a Response object given result data. Syntactic sugar.
      def self.build_from_result data
        Response.new data
      end

      # Initialize a new Response class from the XMLRPC result data
      #
      # ==== Attributes
      #
      #  +data+ - The raw data of an XMLRPC call, usually being a hash that contains
      #           at least two elements: :resultCode (a three-digit numeric code)
      #           and :resultDesc (a human-readable message describing the response).
      def initialize data
        @code    = data.delete 'resultCode' || 0
        @message = data.delete 'resultDesc' || RESPONSE_CODES[@code]
        @data    = data
      end

      # A predicate method to detect a successful response.
      #
      # ==== Example
      #
      #   response = portal.keys.retrieve 'PLSK.00000000.0000'
      #   puts "Retreiving key was successful." if response.success?
      #
      # ==== Note
      #
      # If this request was successful, it should have a result code
      # in the 1xx range as documented in Parallels API documentation.
      def success?
        ( @code % 1000 ) / 100 == 1
      end

      # If it was a failure, it's obviously not successful. Ingenious!
      def error?
        not success?
      end

      #
      def [] key
        str = key.to_s.dup
        str.gsub!(/\/(.?)/){ "::#{$1.upcase}" }
        str.gsub!(/(?:_+|-+)([a-z])/){ $1.upcase }
        str.gsub!(/(\A|\s)([A-Z])/){ $1 + $2.downcase }
        @data[str] || nil
      end
    end

  end

end

#EOF
