Parallels Key Administration API
================================

A quick interface to connect to Parallels Key Administration API and perform
various tasks:

 - License purchasing and termination
 - Usage and statistics information
 - Key information and retrieval
 - License auditing

Installation
------------

 1. Check out the source with `git clone git://github.com/jmkeyes/parallels-key-administrator.git`
 2. Build and install them gem with `gem build parallels-key-administrator.gemspec` and `gem install -l parallels-key-administrator`.
 3. Add `require 'parallels/key_administrator'` to the script you want to automate.

Developer Usage
---------------

Install the *parallels-key-administrator* gem from source. From there, connecting
to the Parallels Key Administrator API is as simple as filling in the partner API
credentials into the following code (where USERNAME and PASSWORD are replaced with
your Partner API credentials):

    #!/usr/bin/env ruby

    # Import the Parallels Key Administrator gem.
    require 'parallels/key_administrator'

    # Connect to ka.parallels.com with the specified credentials.
    portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => 'USERNAME', :password => 'PASSWORD'

    # Validate your login credentials.
    request = portal.client.login_valid?

    if request.successful?
        puts 'Your credentials are valid and activated.'
    else
        puts 'Your credentials are invalid.'
    end

Every call returns a Parallels::KeyAdministrator::Response object, which exposes
`#successful?` method, allowing you to see the status of the call. There are also
`#code`, `#message`, and `#data` methods that return the error code, the response
message, and a hash of returned data or nil. The error message is a human readable
explanation of the status of the call. The response codes are mapped as follows:

 + `-1` is reserved for XMLRPC faults. The XMLRPC fault code and string are contained in the message.
 + `0 - 600` are reserved for Parallels' Key Administrator error codes.
 + All other code are reserved for the time being.

If you want to understand something better, just read the source. The comments are
easy enough to understand.

Administration Utility
----------------------

A utility to access the functionality of this gem is convieniently bundled with it. Simply
install the gem as per the instructions above and invoke the `parallels-key-administrator`
utility from the command line. To learn more about the options it provides, simply invoke
the command without any arguments or by using the `--help` command line option.
