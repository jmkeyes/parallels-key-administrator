# lib/parallels/key_administrator/api/common/client_info.rb

module Parallels

  module KeyAdministrator

    module API

      module Common

        ClientInfo = Struct.new 'login', 'password',
          'firstName', 'lastName', 'company', 'address',
          'email', 'phone', 'fax', 'city', 'zip', 'state',
          'country', 'language', 'email_language' do
            def self.from_details details
              info = ClientInfo.new

              info.login     = details[:username]
              info.password  = details[:password]

              info.firstName = details[:first_name]
              info.lastName  = details[:last_name]

              info.company   = details[:company]

              info.email     = details[:email]
              info.phone     = details[:phone]
              info.fax       = details[:fax]

              info.city      = details[:city]
              info.address   = details[:address]
              info.zip       = details[:zip_code] || details[:postal_code]
              info.state     = details[:state] || details[:province]
              info.country   = details[:country]

              info.language       = details[:language]
              info.email_language = details[:email_language]

              info
            end

        end

      end

    end

  end

end

#EOF
