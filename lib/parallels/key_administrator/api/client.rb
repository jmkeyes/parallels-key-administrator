# lib/parallels/key_administrator/api/client.rb

module Parallels #:nodoc: Already documented.

  module KeyAdministrator #:nodoc: Already documented.

    module API #:nodoc: Already documented.

      # = PKA::API::Client
      #
      # A class to handle all client-related methods.
      class Client
        def initialize portal
          raise 'Must be constructed with a portal instance.' unless portal
          @portal = portal
        end

        # Create a new client from some information.
        #
        # ==== Attributes
        #
        #  +details+ - The details of the new client to be created.
        #
        # ==== Options
        #
        #  +:unknown+ - Unknown parameters.
        #
        def create details
          #handle 'partner10.createClient', details
          raise NotImplementedError, "This method is currently not implemented."
        end

        # Find a client given some information in a hash.
        #
        # ==== Attributes
        #
        #  +details+ - The criteria to look for in the client search.
        #
        # ==== Options
        #
        #  +:unknown+ - Unknown parameters.
        #
        def find_by details
          search_details = Common::ClientSearchInfo.from_criteria details
          @portal.request 'partner10.searchClients', search_details
        end

        # Check if these login credentials are valid.
        #
        # ==== Example
        #
        #     puts "Login credentials are valid." if portal.clients.login_valid?
        #
        def login_valid?
          @portal.request 'partner10.validateLogin'
        end

        # Generate a new password for this client.
        #
        # ==== Example
        #
        #     password = portal.clients.generate_new_password!
        #     puts "New password is now '#{password}'." if password
        #
        def generate_new_password!
          @portal.request 'partner10.generateNewPassword'
        end

      end

    end

  end

end

#EOF
