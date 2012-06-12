# lib/parallels/key_administrator/api/key.rb

require 'parallels/key_administrator/api/base'

module Parallels #:nodoc: Already documented.

  module KeyAdministrator #:nodoc: Already documented.

    module API #:nodoc: Already documented.

      # = Parallels::KeyAdministrator::API::Key
      #
      # A class to handle all client-related methods.
      class Key < Base

        # Activate a key that uses a hardware ID, like Virtuozzo.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +uid+    - ???
        #
        def self.activate_with_hwid number, uid
          handle 'partner10.activateKey', number, uid do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Activate a key that doesn't use a hardware ID, like SiteBuilder.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #
        def self.activate number
          handle 'partner10.activateKey', number do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Add a note (text blob) to a given key that will show up in the portal.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +note+   - Text to include with the key.
        #
        def self.add_note! number, note
          handle 'partner10.addNoteToKey', number, note do |response|
            response.success?
          end
        end

        # Associate a given key to a main key number.
        #
        # ==== Attributes
        #
        #  +main+  - The main license key number.
        #  +child+ - The child license key number to associate.
        #
        def self.attach main, child
          handle 'partner10.attachKey', main, child do |response|
            response.success?
          end
        end

        # De-associate a given child key from it's parent.
        #
        # ==== Attributes
        #
        #  +child+ - A license key number to detach from it's parent.
        #
        def self.detach child
          handle 'partner10.detachKey', child do |response|
            response.success?
          end
        end

        # Bind a key to a specified IP address.
        #
        # ==== Attributes
        #
        #  +number+  - A license key number to bind.
        #  +address+ - The IP address to bind the license key to.
        #
        def self.bind number, address
          handle 'partner10.bindKey', number, address do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Unbinds a key from any IP address.
        #
        # ==== Attributes
        #
        #  +number+ - The license key number to unbind from it's IP address.
        #
        def self.unbind number
          handle 'partner10.unbindKey', number do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Order/purchase a new key as needed.
        #
        # ==== Attributes
        #
        #  +arguments+ - Unknown arguments.
        #
        def self.create *arguments
          raise NotImplementedError, "This method is currently not implemented."
        end

        # Upgrade a key to a new plan.
        #
        # ==== Attributes.
        #
        #  +number+ - A license key number.
        #  +plan+   - A plan to upgrade this key to.
        #
        def self.upgrade number, plan
          raise NotImplementedError, "This method is currently not implemented."
        end

        # Downgrade a key to a new plan.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +plan+   - A plan to downgrade this key to.
        #
        def self.downgrade number, plan
          handle 'partner10.downgradeKey', number, plan do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Get the available types and features a reseller is allowed to purchase.
        #
        # ==== Attributes
        #
        #  +reseller+ - The reseller to retrieve available key types and features for.
        #
        def self.available_types_and_features reseller
          handle 'partner10.getAvailableKeyTypesAndFeatures', reseller do |response|
            response.data if response.success? or nil
          end
        end

        # Find available upgrades for a key.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number to find upgrades for.
        #
        def self.available_upgrades number
          handle 'partner10.getAvailableUpgrades', number do |response|
            response.data[:upgrade_plans] if response.success? or nil
          end
        end

        # Lookup key information by it's key number.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number to get metadata for.
        #
        def self.metadata number
          handle 'partner10.getKeyInfo', number do |response|
            response[:key_info] if response.success? or nil
          end
        end

        # Lookup a key by IP address.
        #
        # ==== Attributes
        #
        #  +address+ - An IP address to look up any attached license keys.
        #
        def self.lookup address
          handle 'partner10.getKeysInfoByIP', address do |response|
            response.data[:keys_info] if response.success? or nil
          end
        end

        # Find keys by a given a list of :ips or :macs.
        #
        # ==== Attributes
        #
        #  +criteria+ - A hash of IP or MAC addresses to lookup they keys attached to.
        #
        # ==== Options
        #
        #  +:ips+  - An array of IP addresses in dotted-quad form to search for.
        #  +:macs+ - An array of MAC addresses in standard form to search for.
        #
        def self.find_by criteria
          info = Common::ServerAddressInfo.from_criteria criteria
          handle 'partner10.getKeyNumbers', info do |response|
            response.data if response.success? or nil
          end
        end

        # Retrieves the last usage information reported by Plesk for a key.
        #
        # ==== Attributes
        #
        #  +number+ - Retrieve the usage information for this license key.
        #
        def self.last_usage_info number
          handle 'partner10.getLastPleskUsageInfo', number do |response|
            response.data[:last_usage_info] if response.success? or nil
          end
        end

        # Renews the license for this key.
        #
        # ==== Attributes
        #
        #  +number+ - Renew the license with this license key number.
        #
        def self.renew number
          handle 'partner10.renewKey', number do |response|
            response.data if response.success? or nil
          end
        end

        # Resets any UID and deactivates the license for this key. (VZ)
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #
        def self.reset number
          handle 'partner10.resetKey', number do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Retrieves the binary copy of the specified key.
        #
        # ==== Attributes
        #
        #  +number+     - The license key number to retrieve.
        #  +compatible+ - Should this license be backwards
        #                 with a previous version?
        #
        def self.retrieve number, compatible = false
          handle 'partner10.retrieveKey', number, compatible do |response|
            response.data if response.success? or nil
          end
        end

        # Sends Key to the specified e-mail address, or the owner's e-mail address, possibly in ZIP format.
        #
        # ==== Attributes
        #
        #  +number+     - The license key number to retrieve and send.
        #  +recipient+  - The email address that should receieve this key.
        #  +compressed+ - Should the license key be compressed in a ZIP archive?
        def self.send_by_email number, recipient, compressed = true
          handle 'partner10.sendKeyByEmail', number, recipient, compressed do |response|
            response.success?
          end
        end

        # Terminates the specified key.
        #
        # ==== Attributes
        #
        #  +number+ - The license key number to terminate.
        #
        def self.terminate number
          handle 'partner10.terminateKey', number do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

        # Transfer a Virtuozzo key to another hardware ID.
        #
        # ==== Attributes
        #
        #  +number+      - The license key number to transfer.
        #  +hardware_id+ - The new hardware ID to transfer the license to.
        #
        def self.transfer number, hardware_id
          handle 'partner10.transferKey', number, hardware_id do |response|
            response.data[:key_number] if response.success? or nil
          end
        end

      end

    end

  end

end

#EOF
