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
 2. Build and install them gem with `gem build parallels-key-administrator.gemspec && gem install -l parallels-key-administrator`.
 3. Add `require 'parallels/key_administrator'` to the script you want to automate.

Developer Usage
---------------

Install the *parallels-key-administrator* gem from source. From there, connecting to
the Parallels Key Administrator API is as simple as filling in the partner API
credentials into the following code (where USERNAME and PASSWORD are replaced with
your Partner API credentials):

    #!/usr/bin/env ruby

    # Import the Parallels Key Administrator gem.
    require 'parallels/key_administrator'

    # Connect to ka.parallels.com with the specified credentials.
    portal = Parallels::KeyAdministrator::Portal.new 'ka.parallels.com', :username => 'USERNAME', :password => 'PASSWORD'

    # Validate your login credentials.
    if portal.client.login_valid?
        puts 'Your credentials are valid and activated.'
    else
        puts 'Your credentials are invalid.'
    end

For the moment, just read the source. I hope the comments are easy enough to understand.

Administration Utility
----------------------

A utility to access the functionality of this gem is convieniently bundled with it. Simply
install the gem as per the instructions above and invoke the `parallels-key-administrator`
utility from the command line. To learn more about the options it provides, simply invoke
the command without any arguments or by using the `--help` command line option.

