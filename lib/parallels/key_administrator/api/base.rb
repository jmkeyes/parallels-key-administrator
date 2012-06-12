# lib/parallels/key_administrator/api/base.rb

require 'parallels/key_administrator/api/common'

module Parallels #:nodoc: Already documented.

  module KeyAdministrator #:nodoc: Already documented.

    module API #:nodoc: Already documented.

      # = Parallels::KeyAdministrator::API::Base
      #
      # A base class that all API request handling should inherit from.
      class Base

        # Syntactically restructure a method call to return parameters as needed by the client.
        #
        # ==== Attributes
        #
        #  +name+       - The name of the XMLRPC method to call.
        #  +parameters* - A list of parameters for the method call.
        #  +block+      - An optional block to handle the response of the call.
        #
        # ==== Examples
        #
        #     class Client < Base
        #       # ...
        #
        #       def login_valid?
        #         handle 'partner10.validateLogin' do |response|
        #           response.success?
        #         end
        #       end
        #
        #       # ...
        #     end
        #
        # ==== Note
        #
        # This helps the structure the data returned from each method so that the proy can handle
        # the trailing optional block. There's probably a way to reduce or remove this, but I it
        # could be useful in the future to keep around.
        def self.handle name, *parameters, &block
          return name, *parameters, block
        end

      end

    end

  end

end

#EOF
