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
	<LI>files2static.sh: <i>run in the project directory</i>
	<LI>static2files.sh: <i>run in the project directory</i>
</UL>

<B>Added:</B> Static Resource Management.  files2static will create static resources from a files directory in the same project folder.  Any directories within /files will be zipped into one Static Resource.  static2files will do the reverse, and inflate any zipped resources.

<B>BOTH</B> operations are auto-destructive on a client level.  They'll delete the target directory before processing.  This won't delete anything when using the Migration tool.

The difference between "compilegist" and "rungist" is that rungist just runs the Apex anonymously.
The oauth.sh script will spin up a small node server and open a browser to go through the OAuth flow.  Requires you to have "consumerkey" and "privatekey" set in build.properties.

Example of compiling from a project folder with the scripts in the root might be:

<I>compile.sh classes/Classname.cls build.properties</I>

Currently the gist compiler only supports Apex.  Will be fixed shortly.

Questions?  On twitter @joshbirk.