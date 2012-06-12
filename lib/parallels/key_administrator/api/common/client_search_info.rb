# lib/parallels/key_administrator/api/common/client_info.rb

module Parallels

  module KeyAdministrator

    module API

      module Common

        ClientSearchInfo = Struct.new 'firstName', 'lastName', 'companyName', 'email', 'keyNumber' do

          def self.from_criteria data
            # Create a new instance.
            info = ClientSearchInfo.new

            # Populate with any fields, if given.
            info.firstName   = data[:first_name]
            info.lastName    = data[:last_name]
            info.companyName = data[:company_name]
            info.email       = data[:email]
            info.keyNumber   = data[:key_number]

            # Return the new object.
            info
          end

        end

      end

    end

  end

end

#EOF
