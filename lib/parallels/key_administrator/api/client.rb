# lib/parallels/key_administrator/api/client.rb

require 'parallels/key_administrator/api/base'

module Parallels #:nodoc: Already documented.

  module KeyAdministrator #:nodoc: Already documented.

    module API #:nodoc: Already documented.

      # = PKA::API::Client
      #
      # A class to handle all client-related methods.
      class Client < Base

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
        def self.create details
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
        def self.find_by details
          search_details = Common::ClientSearchInfo.from_criteria details
          handle 'partner10.searchClients', search_details
        end

        # Check if these login credentials are valid.
        #
        # ==== Example
        #
        #     puts "Login credentials are valid." if portal.clients.login_valid?
        #
        def self.login_valid?
          handle 'partner10.validateLogin' do |response|
            # If the call was successful then we have valid credentials.
            response.success?
          end
        end

        # Generate a new password for this client.
        #
        # ==== Example
        #
        #     password = portal.clients.generate_new_password!
        #     puts "New password is now '#{password}'." if password
        #
        def self.generate_new_password!
          handle 'partner10.generateNewPassword' do |response|
            # Return the new password if the call was successful, or nil.
            response.data['newPassword'] if response.success? or nil
          end
        end

      end

    end

  end

end

#EOF
