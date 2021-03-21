---
titles: Update DNS Records | namesilo
date: 2020-04-07 12:14:00
---

> <https://www.namesilo.com/api-reference#dns>

## Request Formatting
All requests made to the API should use the following standard format:

    https://www.namesilo.com/api/OPERATION?version=VERSION&type=TYPE&key=YOURAPIKEY

### More information on each part of the standard request is as follows:
**https**: All requests to the API must utilize https.
**OPERATION**: To be replaced by the name of the specific operation you would like to execute.
**VERSION**: To be replaced by the API version you would like to use. The current version is "1".
**TYPE**: To be replaced by the format you would like to receive returned. The only current option is "xml".
**YOURAPIKEY**: To be replaced by your unique API key. Visit the API Manager page within your account for details.


<!--more-->


---

List Current DNS Records
View all of the current DNS records associated with the domain. You will need the "record_id" value to perform the dnsUpdateRecord and dnsDeleteRecord functions below.

Sample Request

    https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=12345&domain=namesilo.com

Request Parameters
domain: The domain being requested
Response

    <namesilo>
    	<request>
    		<operation>dnsListRecords</operation>
    		<ip>55.555.55.55</ip>
    	</request>
    	<reply>
    		<code>300</code>
    		<detail>success</detail>
    		<resource_record>
    			<record_id>1a2b3c4d5e6f</record_id>
    			<type>A</type>
    			<host>test.namesilo.com</host>
    			<value>55.555.55.55</value>
    			<ttl>7207</ttl>
    			<distance>0</distance>
    		</resource_record>
    		<resource_record>
    			<record_id>5Brg5hw25jr</record_id>
    			<type>CNAME</type>
    			<host>dev.namesilo.com</host>
    			<value>testing.namesilo.com</value>
    			<ttl>7207</ttl>
    			<distance>0</distance>
    		</resource_record>
    		<resource_record>
    			<record_id>fH35aH4hsv</record_id>
    			<type>MX</type>
    			<host>namesilo.com</host>
    			<value>mail.namesilo.com</value>
    			<ttl>7207</ttl>
    			<distance>10</distance>
    		</resource_record>
    		<resource_record>
    			<record_id>Ldfd26Sfbh</record_id>
    			<type>MX</type>
    			<host>namesilo.com</host>
    			<value>mail2.namesilo.com</value>
    			<ttl>7207</ttl>
    			<distance>20</distance>
    		</resource_record>
    	</reply>
    </namesilo>

Operation-Specific Responses
type: Possible values are "A", "AAAA", "CNAME", "MX" and "TXT"

---

Add DNS Records
Adds a new DNS resource record to the selected domain.

Sample Request

    https://www.namesilo.com/api/dnsAddRecord?version=1&type=xml&key=12345&domain=namesilo.com&rrtype=A&rrhost=test&rrvalue=55.55.55.55&rrttl=7207

Request Parameters
domain: The domain being updated
rrtype: The type of resources record to add. Possible values are "A", "AAAA", "CNAME", "MX" and "TXT"
rrhost: The hostname for the new record (there is no need to include the ".DOMAIN")
rrvalue: The value for the resource record
A - The IPV4 Address
AAAA - The IPV6 Address
CNAME - The Target Hostname
MX - The Target Hostname
TXT - The Text
rrdistance: Only used for MX (default is 10 if not provided)
rrttl: The TTL for the new record (default is 7207 if not provided)
Response

    <namesilo>
    	<request>
    		<operation>dnsAddRecord</operation>
    		<ip>55.555.55.55</ip>
    	</request>
    	<reply>
    		<code>300</code>
    		<detail>success</detail>
    		<record_id>1a2b3c4d5e</record_id>
    	</reply>
    </namesilo>   

Operation-Specific Responses
record_id: The unique ID of the resource record that was created. This value is necessary to perform the dnsUpdateRecord and dnsDeleteRecord functions below.

---

Delete DNS Records
Delete an existing DNS resource record.

Sample Request

    https://www.namesilo.com/api/dnsDeleteRecord?version=1&type=xml&key=12345&domain=namesilo.com&rrid=1a2b3

Request Parameters
domain: The domain associated with the DNS resource record to delete
rrid: The unique ID of the resource record. You can get this value using dnsListRecords.
Response

    <namesilo>
    	<request>
    		<operation>dnsDeleteRecord</operation>
    		<ip>55.555.55.55</ip>
    	</request>
    	<reply>
    		<code>300</code>
    		<detail>success</detail>
    	</reply>
    </namesilo>

**
If you delete any resource records associated with sub-domain forwarding then the forwarding will be automatically removed and no longer work.

---

# Update an existing DNS resource record.

## Sample Request
```
https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=12345&domain=namesilo.com&rrid=1a2b3&rrhost=test&rrvalue=55.55.55.55&rrttl=7207
```
### Request Parameters
**domain**: The domain associated with the DNS resource record to modify
**rrid**: The unique ID of the resource record. You can get this value using dnsListRecords.
**rrhost**: The hostname to use (there is no need to include the ".DOMAIN")
**rrvalue**: The value for the resource record
  - A - The IPV4 Address
  - AAAA - The IPV6 Address
  - CNAME - The Target Hostname
  - MX - The Target Hostname
  - TXT - The Text

**rrdistance**: Only used for MX (default is 10 if not provided)
**rrttl**: The TTL for this record (default is 7207 if not provided)

## Response
```
<namesilo>
	<request>
		<operation>dnsUpdateRecord</operation>
		<ip>55.555.55.55</ip>
	</request>
	<reply>
		<code>300</code>
		<detail>success</detail>
		<record_id>1a2b3c4d5e</record_id>
	</reply>
</namesilo>
```
### Operation-Specific Responses
**record_id**: The new unique ID for the resource record that was updated. Any successful updates will result in a new record_id.