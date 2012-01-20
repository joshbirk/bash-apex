echo "Running Gist"
api=22 #default
. "${2}"

if [ ${usekeychainaccess} == 'enabled' ]
	then 
	password=$("./keychain.sh" ${password})
fi

session=0
#determine session
if [ -f ".session" ] 
	then
	session=$(cat .session)
else
	if [ ! -n "${consumerkey+x}" ]
	then
		echo "Retrying SOAP Login..."
		
		data=$(curl -s -d "<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:enterprise.soap.sforce.com\"><soapenv:Body><urn:login><urn:username>${username}</urn:username><urn:password>${password}</urn:password></urn:login></soapenv:Body></soapenv:Envelope>" -H "Content-Type: text/xml; charset=utf-8" -H "SOAPAction:'' " ${serverurl}/services/Soap/u/11.1)
		echo $data > response.xml

		session=$(sed -n -e 's/.*<sessionId>\(.*\)<\/sessionId>.*/\1/p' response.xml)
		rm response.xml
	else
		echo "Retrying OAUTH Login..."
		json=$(curl -d "grant_type=password&client_id=${consumerkey}&client_secret=${privatekey}&username=${username}&password=${password}" ${serverurl}/services/oauth2/token)
		IFS=':' read -ra data <<< "$json"
	
		session1=${data[7]}
		session0=${session1:1}
		session=${session0/\"\}/}
	fi
	echo $session > .session
fi

code=$(curl "https://raw.github.com/gist/${1}")

echo "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:apex=\"http://soap.sforce.com/2006/08/apex\">
   <soapenv:Header>
    <apex:DebuggingHeader>
	         <apex:categories>
	            <apex:category>Apex_code</apex:category>
	            <apex:level>FINEST</apex:level>
	         </apex:categories>
	         <apex:debugLevel>DETAIL</apex:debugLevel>
	      </apex:DebuggingHeader>  
	<apex:SessionHeader>
      <apex:sessionId>${session}</apex:sessionId>
      </apex:SessionHeader>
   </soapenv:Header>
   <soapenv:Body>
      <apex:executeAnonymous>
         <apex:String>
		  <![CDATA[
			${code}
		   ]]>
		</apex:String>
      </apex:executeAnonymous>
   </soapenv:Body>
</soapenv:Envelope>" > request.xml

data=$(curl -s --data @request.xml  -H "Content-Type: text/xml; charset=utf-8" -H "X-PrettyPrint:1" -H "SOAPAction:'' " https://${pod}-api.salesforce.com/services/Soap/s/${api}.0)

echo ''
		
echo $data > response.xml
debuglog=$(sed -n -e 's/.*<debugLog>\(.*\)<\/debugLog>.*/\1/p' response.xml)
error=$(sed -n -e 's/.*<compileProblem>\(.*\)<\/compileProblem>.*/\1/p' response.xml)
sessioncheck=$(grep -ic "INVALID_SESSION" "response.xml")
rm request.xml
rm response.xml

echo $debuglog | tr '\|' '\n'
echo $error | tr '\|' '\n'

if [ "$sessioncheck" != "0" ]
	then
	echo '\nInvalid Session.  Clearing old session, please try again'
	rm .session
fi

