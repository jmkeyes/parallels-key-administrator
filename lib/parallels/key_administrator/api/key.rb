# lib/parallels/key_administrator/api/key.rb

module Parallels #:nodoc: Already documented.

  module KeyAdministrator #:nodoc: Already documented.

    module API #:nodoc: Already documented.

      # = Parallels::KeyAdministrator::API::Key
      #
      # A class to @portal.request all client-related methods.
      class Key
        def initialize portal
          raise 'Must be constructed with a portal instance.' unless portal
          @portal = portal
        end

        # Activate a key that uses a hardware ID, like Virtuozzo.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +uid+    - ???
        #
        def activate_with_hwid key_number, uid
          @portal.request 'partner10.activateKey', key_number, uid
        end

        # Activate a key that doesn't use a hardware ID, like SiteBuilder.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #
        def activate key_number
          @portal.request 'partner10.activateKey', key_number
        end

        # Add a note (text blob) to a given key that will show up in the portal.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +note+   - Text to include with the key.
        #
        def add_note! key_number, note
          @portal.request 'partner10.addNoteToKey', key_number, note
        end

        # Associate a given key to a main key number.
        #
        # ==== Attributes
        #
        #  +main+  - The main license key number.
        #  +child+ - The child license key number to associate.
        #
        def attach main_key, child_key
          @portal.request 'partner10.attachKey', main_key, child_key
        end

        # De-associate a given child key from it's parent.
        #
        # ==== Attributes
        #
        #  +child+ - A license key number to detach from it's parent.
        #
        def detach child
          @portal.request 'partner10.detachKey', child
        end

        # Bind a key to a specified IP address.
        #
        # ==== Attributes
        #
        #  +number+  - A license key number to bind.
        #  +address+ - The IP address to bind the license key to.
        #
        def bind number, address
          @portal.request 'partner10.bindKey', number, address
        end

        # Unbinds a key from any IP address.
        #
        # ==== Attributes
        #
        #  +number+ - The license key number to unbind from it's IP address.
        #
        def unbind number
          @portal.request 'partner10.unbindKey', number
        end

        # Order/purchase a new key as needed.
        #
        # ==== Attributes
        #
        #  +arguments+ - Unknown arguments.
        #
        def create *arguments
          raise NotImplementedError, "This method is currently not implemented."
        end

        # Upgrade a key to a new plan.
        #
        # ==== Attributes.
        #
        #  +number+ - A license key number.
        #  +plan+   - A plan to upgrade this key to.
        #
        def upgrade number, plan
          raise NotImplementedError, "This method is currently not implemented."
        end

        # Downgrade a key to a new plan.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #  +plan+   - A plan to downgrade this key to.
        #
        def downgrade number, plan
          @portal.request 'partner10.downgradeKey', number, plan
        end

        # Get the available types and features a reseller is allowed to purchase.
        #
        # ==== Attributes
        #
        #  +reseller+ - The reseller to retrieve available key types and features for.
        #
        def available_types_and_features reseller
          @portal.request 'partner10.getAvailableKeyTypesAndFeatures', reseller
        end

        # Find available upgrades for a key.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number to find upgrades for.
        #
        def available_upgrades number
          @portal.request 'partner10.getAvailableUpgrades', number
        end

        # Lookup key information by it's key number.
        #
        # ==== Attributes
        #
        #  +number+ - A license key number to get metadata for.
        #
        def metadata number
          @portal.request 'partner10.getKeyInfo', number
        end

        # Lookup a key by IP address.
        #
        # ==== Attributes
        #
        #  +address+ - An IP address to look up any attached license keys.
        #
        def lookup address
          @portal.request 'partner10.getKeysInfoByIP', address
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
        def find_by criteria
          info = Common::ServerAddressInfo.from_criteria criteria
          @portal.request 'partner10.getKeyNumbers', info
        end

        # Retrieves the last usage information reported by Plesk for a key.
        #
        # ==== Attributes
        #
        #  +number+ - Retrieve the usage information for this license key.
        #
        def last_usage_info number
          @portal.request 'partner10.getLastPleskUsageInfo', number
        end

        # Renews the license for this key.
        #
        # ==== Attributes
        #
        #  +number+ - Renew the license with this license key number.
        #
        def renew number
          @portal.request 'partner10.renewKey', number
        end

        # Resets any UID and deactivates the license for this key. (VZ)
        #
        # ==== Attributes
        #
        #  +number+ - A license key number.
        #
        def reset number
          @portal.request 'partner10.resetKey', number
        end

        # Retrieves the binary copy of the specified key.
        #
        # ==== Attributes
        #
        #  +number+     - The license key number to retrieve.
        #  +compatible+ - Should this license be backwards
        #                 with a previous version?
        #
        def retrieve number, compatible = false
          @portal.request 'partner10.retrieveKey', number, compatible
        end

        # Sends Key to the specified e-mail address, or the owner's e-mail address, possibly in ZIP format.
        #
        # ==== Attributes
        #
        #  +number+     - The license key number to retrieve and send.
        #  +recipient+  - The email address that should receieve this key.
        #  +compressed+ - Should the license key be compressed in a ZIP archive?
        def send_by_email number, recipient, compressed = true
          @portal.request 'partner10.sendKeyByEmail', number, recipient, compressed
        end

        # Terminates the specified key.
        #
        # ==== Attributes
        #
        #  +number+ - The license key number to terminate.
        #
        def terminate number
          @portal.request 'partner10.terminateKey', number
        end

        # Transfer a Virtuozzo key to another hardware ID.
        #
        # ==== Attributes
        #
        #  +number+      - The license key number to transfer.
        #  +hardware_id+ - The new hardware ID to transfer the license to.
        #
        def transfer number, hardware_id
          @portal.request 'partner10.transferKey', number, hardware_id
        end

      end

    end

  end

end

#EOF
