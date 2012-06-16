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
    class Portal

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
      def initialize host, opts = {}
        options = {
          :username => 'anonymous',
          :password => '',
          :insecure => false,
          :timeout  => DEFAULT_TIMEOUT,
          :port     => DEFAULT_PORT,
          :debug    => false
        }.merge(opts)

        @credentials = API::Common::AuthInfo.new options[:username], options[:password]

        @rpc = XMLRPC::Client.new host, '/', options[:port], nil, nil, nil, nil, true, options[:timeout]

        if options[:insecure] or options[:debug]
          # This is really ugly. Doesn't XMLRPC::Client have this ability? Maybe monkey patch it in?
          http = @rpc.instance_variable_get :@http
          http.instance_variable_set :@verify_mode, OpenSSL::SSL::VERIFY_NONE if options[:insecure]
          http.set_debug_output($stderr) if options[:debug]
        end
      end

      # Action a request to the key administration portal.
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
      #     response = portal.request 'partner10.validateLogin'
      #     puts "You have valid credentials." if response.success?
      #
      # ==== Note
      #
      # Use of the proxy methods noted above is preferred, as this method does not shield
      # the user for the retarded broken-ness of Parallels' badly designed API.
      #
      def request method, *arguments, &callback
        ok, result = @rpc.call2 method, @credentials, *arguments

        # Post process the response using an optional callback.
        callback ||= lambda { |_result| Response.from_result _result }

        if ok
          instance_exec result, &callback
        else
          Response.from_fault result
        end
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
        @client_ops ||= API::Client.new self
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
        @key_ops ||= API::Key.new self
      end
    end

  end

end

#EOF
