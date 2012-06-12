# lib/parallels/key_administrator/api/common/server_address_info.rb

module Parallels
  module KeyAdministrator
    module API
      module Common
        ServerAddressInfo = Struct.new :ips, :macs do
          def self.from_criteria criteria
            ips  = criteria[:ips] || []
            macs = criteria[:macs] || []

            ServerAddressInfo.new ips, macs
          end
        end
      end
    end
  end
end

#EOF
