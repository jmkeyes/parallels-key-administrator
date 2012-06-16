# lib/parallels/key_administrator/response.rb

module Parallels #:nodoc: Already documented

  module KeyAdministrator #:nodoc: Already documented

    # = PKA::Response
    #
    # The response class for an XMLRPC request.
    class Response

      # Response codes as documented by Parallels' API Guide.
      RESPONSE_CODES = {
        # XMLRPC Fault.
        -1 => 'Unknown XMLRPC Fault.',

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
      def self.from_result result
        code    = result.delete 'resultCode'
        message = result.delete 'resultDesc'
        Response.new code, message, result
      end

      # Build a Response object given an XMLRPC fault.
      def self.from_fault fault
        Response.new -1, "#{fault.faultString} (#{fault.faultCode})", fault
      end

      # Initialize a new Response class from the XMLRPC result data
      #
      # ==== Attributes
      #
      #  +data+ - The raw data of an XMLRPC call, usually being a hash that contains
      #           at least two elements: :resultCode (a three-digit numeric code)
      #           and :resultDesc (a human-readable message describing the response).
      def initialize code, message, data = nil
        @code    = code
        @message = message
        @data    = data
      end

      # A predicate method to detect a successful response.
      #
      # ==== Example
      #
      #   response = portal.keys.retrieve 'PLSK.00000000.0000'
      #   puts "Retreiving key was successful." if response.successful?
      #
      # ==== Note
      #
      # If this request was successful, it should have a result code
      # in the 1xx range as documented in Parallels API documentation.
      def successful?
        ( @code % 1000 ) / 100 == 1
      end

      #
      def [] index
        # Convert :snake_case into lowerCamelCase for key lookup.
        key = index.to_s.dup
        key.gsub!(/\/(.?)/){ "::#{$1.upcase}" }
        key.gsub!(/(?:_+|-+)([a-z])/){ $1.upcase }
        key.gsub!(/(\A|\s)([A-Z])/){ $1 + $2.downcase }
        @data[key] if data or nil
      end
    end

  end

end

#EOF
