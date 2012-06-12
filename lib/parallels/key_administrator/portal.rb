# lib/parallels/key_administrator/portal.rb

require 'xmlrpc/client'
require 'parallels/key_administrator/api'
require 'parallels/key_administrator/response'

module Parallels #:nodoc: Already documented

  module KeyAdministrator #:nodoc: Already documented

    # = Parallels::KeyAdministrator::Portal
    #
    # This is the main class users should be interacting with. It sub-classes the XMLRPC
    # client bundled with Ruby to provide a custom interface to the key administration
    # portal.
    #
    # == Example
    #
    #   portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
    #   puts portal.help :clients
    #
    # == Dependencies
    #
    #   Requires the XMLRPC client bundled with Ruby.
    #
    class Portal < ::XMLRPC::Client

      # The default port that the Key Administrator gateway runs on.
      DEFAULT_PORT    = 7050

      # The suggested network timeout, accoring to the documentation.
      DEFAULT_TIMEOUT = 900

      # Create a new client for the portal specified.
      #
      # ==== Attributes
      #
      #  +host+    - The hostname of the portal to connect to, which should be either
      #              'ka.parallels.com' (production) or 'kademo.parallels.com' (testing).
      #  +options+ - A hash containing the configuration of this client connection:
      #
      #  * +:username+ - The username used to connect to the portal.                (default: 'anonymous')
      #  * +:password+ - The password used to connect to the portal.                (default: none)
      #  * +:insecure+ - Ignore SSL certificate errors when connecting.             (default: false)
      #  * +:timeout+  - The amount of time in milliseconds to wait for a response. (default: 900)
      #  * +:port+     - The port to connect to for the XMLRPC service.             (default: 7050)
      #
      # ==== Example
      #
      #     portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
      #
      # ==== Note
      #
      # This is the first method for any call and is obviously required to use this library.
      def initialize host, options = {}
        options = {
          :username => 'anonymous',
          :password => '',
          :insecure => false,
          :timeout  => DEFAULT_TIMEOUT,
          :port     => DEFAULT_PORT
        }.merge(options)

        username = options[:username]
        password = options[:password]
        timeout  = options[:timeout]
        port     = options[:port]

        @credentials = API::Common::AuthInfo.new username, password

        super host, '/', port, nil, nil, nil, nil, true, timeout

        @http.instance_variable_set(:@verify_mode, OpenSSL::SSL::VERIFY_NONE) if options[:insecure]
      end

      # Proxy all calls to the API::Client class.
      #
      # ==== Example
      #
      #     portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
      #     client = portal.client.find_by :email => 'joe@domain.com'
      #     puts client['companyName'] if client
      #
      # ==== Note
      #
      # This method proxies all calls to the Parallels::KeyAdministrator::API::Client
      # class, which handles the manipulation of clients within the administration
      # portal. You should have the ability to search for and create new clients, as
      # well as verify your login credentials or automatically generate a new password
      # for your logon here.
      def client
        class << proxy = Object.new
          def method_missing method, *arguments
            name, *parameters, callback = API::Client.send method, *arguments

            response = @client.call name, *parameters

            callback ||= lambda { |response| response }

            instance_exec response, &callback
          end
        end

        # Give this object access to our instance.
        proxy.instance_variable_set(:@client, self)

        # Proxy the call.
        proxy
      end

      # Proxy calls to the API::Key class.
      #
      # ==== Example
      #
      #     portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
      #     data = portal.key.retrieve 'PLSK.00000000.0000'
      #     puts data['key'] if data
      #
      # ==== Note
      #
      # This method proxies all calls to the Parallels::KeyAdministrator::API::Key class,
      # which handles all of the Parallels' Key manipulation functions in the administration
      # portal. You should have the ability to audit, terminate, purchase, renew and transfer
      # licenses here.
      def key
        class << proxy = Object.new
          def method_missing method, *arguments
            name, *parameters, callback = API::Key.send method, *arguments

            response = @client.call name, *parameters

            callback ||= lambda { |response| response }

            instance_exec response, &callback
          end
        end

        # Give this object access to our instance.
        proxy.instance_variable_set(:@client, self)

        # Proxy the call.
        proxy
      end

      # Rudimentary listing of methods provided by each proxy.
      #
      # ==== Example
      #
      #     portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
      #     puts portal.help :client
      #
      # ==== Note
      #
      # This method is only a stepping stone for better documentation of the Parallels'
      # API methods in the future. It is only a basic reference to the methods supplied
      # by the gem, and does not interact with the portal.
      def help topic
        classes = { :client => API::Client, :key => API::Key }
        classes[topic].methods(false) if classes.keys.include? topic
      end

      # Perform an XMLRPC request agains the key administration portal.
      #
      # ==== Attributes
      #
      # +method+    - The XMLRPC method that should be invoked on the server.
      # +arguments+ - Any arguments to be sent to the server with the call. You should
      #               skip the credentials structure as it will be supplied by the client.
      #
      # ==== Example
      #
      #     portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => '', :password => ''
      #     response = portal.call 'partner10.validateLogin'
      #     puts "You have valid credentials." if response.success?
      #
      # ==== Note
      #
      # Use of the proxy methods noted above is preferred, as this method does not shield
      # the user for the retarded broken-ness of Parallels' badly designed API.
      #
      def call method, *arguments
        ok, data = call2 method, @credentials, *arguments
        Response.build_from_result data if ok or nil
      end

    end

  end

end

#EOF
