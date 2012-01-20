<h2>bash-apex</h2>

Simple Bash (OSX) scripts for compiling code against an org

<b>Usage:</b>
<UL>
	<LI>build.properties: put your credentials, pod, login server, etc. info here.
	<LI>compile.sh: <I>compile.sh filename propertiesfile</I>
	<LI>compilegist.sh: <I>compilegist.sh gistid propertiesfile</I>
	<LI>keychain.sh: utility shell script if you have "usekeychainaccess" set to enabled
	<LI>oauth.sh: Alternate to using username and password.  Requires node to be installed.
	<LI>rungist.sh: <i>rungist.sh gistid propertiesfile</i>
</UL>

The difference between "compilegist" and "rungist" is that rungist just runs the Apex anonymously.
The oauth.sh script will spin up a small node server and open a browser to go through the OAuth flow.  Requires you to have "consumerkey" and "privatekey" set in build.properties.

Example of compiling from a project folder with the scripts in the root might be:

<I>compile.sh classes/Classname.cls build.properties</I>

Questions?  On twitter @joshbirk.