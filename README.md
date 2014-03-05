# AppDynamics ServiceNow - Alerting Extension


##Use Case
ServiceNow ([http://www.servicenow.com](www.servicenow.com)) is a software-as-a-service (SaaS) provider of IT service management (ITSM) software. AppDynamics integrates directly with ServiceNow to create tickets in response to alerts. With the ServiceNow integration you can leverage your existing ticketing infrastructure to notify your operations team to resolve performance degradation issues.


##Package

Run ant from servicenow-alerting-extension directory. This will create the following file in the dist directory: ServiceNowAlertingExtension.zip.

##Installation


###1. Download and unzip ServiceNowAlertingExtension.zip
 
Download and unzip the ServiceNowAlertingExtension.zip file into your <Controller-Home> directory.

###2. Modify the parameters in params.sh

Modify the parameters in the ``<Controller Home>/custom/actions/createServiceNowTicket/params.sh`` file as follows:

	a. Assign the ASSIGN\_TO variable to be a person or department account that is authorized in the ServiceNow system and to which auto generated tickets can be assigned.

	b. Assign the DOMAIN variable to be your ServiceNow domain. For example,

		(DOMAIN="[https://sampledomain.service-now.com](https://sampledomain.service-now.com/)")

	c. Assign the USER variable to be the username that will issue these generated tickets.

	d. Assign the PASSWORD variable to be the password of the entered username that will issue these generated tickets.

	e. Assign the SERVICENOW_VERSION variable to be the target version of ServiceNow instance you are sending alerts to. Valid values are "Calgary" and "Dublin".

###3. Upload the ServiceNow update sets
In case you're using the Calgary release, upload the update set found in the ``<Controller Home>/custom/update_sets/AppDynamics4Calgary.xml``
In case you're using the Dublin release, upload the update set found in the ``<Controller Home>/custom/update_sets/AppDynamics.xml``
###4. Modify the createServiceNowTicket.sh file using the following table to correspond with the parameters in the params.sh file:

<table>
	<tr>
	<td><strong>AppDynamics Parameters</strong></td>
	<td><strong>ServiceNow Parameters</td>
	<td><strong>Comments</td>
	</tr>

	<tr>
	<td> </td>
	<td>assigned_to</td>
	<td>This is the field used to assign an incident to an individual/department. The email address or full name of the designated user can be written here. This should be entered into the params.sh file as an email address that is already configured in the ServiceNow environment.</td>
	</tr>
	
	<tr>
	<td>
	<table>
	
	<tr>
	<td>
	APP_NAME</td>
	</tr>
	
	<tr>
	<td>PVN_ALERT_TIME</td>
	</tr>
	
	<tr>
	<td>SEVERITY</td>
	</tr>
	
	<tr>
	<td>POLICY_NAME</td>
	</tr>
	
	<tr>
	<td>AFFECTED_ENTITY_TYPE</td>
	</tr>
	
	<tr>
	<td>AFFECTED_ENTITY_NAME</td>
	</tr>
	
	<tr>
	<td>EVALUATION_TYPE</td>
	</tr>
	
	<tr>
	<td>EVALUATION_ENTITY_NAME</td>
	</tr>
	
	<tr>
	<td>SCOPE_TYPE_x</td>
	</tr>
	
	<tr>
	<td>SCOPE_NAME_x</td>
	</tr>
	
	<tr>
	<td>CONDITION_NAME_x</td>
	</tr>
	
	<tr>
	<td>THRESHOLD_VALUE_x</td>
	</tr>
	
	<tr>
	<td>  
	 OPERATOR_x</td>
	</tr>
	
	<tr>
	<td>BASELINE_NAME_x</td>
	</tr>
	
	<tr>
	<td>USE_DEFAULT_BASELINE_x</td>
	</tr>
	
	<tr>
	<td>OBSERVED_VALUE_x</td>
	</tr>
	
	<tr>
	<td>INCIDENT_ID</td>
	</tr>
	
	<tr>
	<td>DEEP_LINK_URL</td>
	</tr>
	</table>
	</td>
	<td>description</td>
	<td>The format is as follows for the following Policy Violation Parameters:
	
	<table>
	
	<tr>
	<td><strong>Variable name: Variable value</strong></td>
	</tr>
	
	<tr>
	<td>Application Name: APP_NAME</td></td>
	</tr>
	
	<tr>
	<td>Policy Violation Alert Time: PVN_ALERT_TIME</td>
	</tr>
	
	<tr>
	<td>Severity: SEVERITY</td></td>
	</tr>
	
	<tr>
	<td>Name of Violated Policy: POLICY_NAME</td>
	</tr>
	
	<tr>
	<td>Affected Entity Type: AFFECTED_ENTITY_TYPE</td>
	</tr>
	
	<tr>
	<td>Name of Affected Entity: AFFECTED_ENTITY_NAME</td>
	</tr>
	
	<tr>
	<td>Evaluation Entity #x</td>
	</tr>
	
	<tr>
	<td>Evaluation Entity: EVALUATION_TYPE</td>
	</tr>
	
	<tr>
	<td>Evaluation Entity Name: EVALUATION_ENTITY_NAME</td>
	</tr>
	
	<tr>
	<td>Triggered Condition #x</td>
	</tr>
	
	<tr>
	<td>Scope Type: SCOPE_TYPE_x</td>
	</tr>
	
	<tr>
	<td>
	Scope Name: SCOPE_NAME_x</td>
	</tr>
	
	<tr>
	<td>CONDITION_NAME_x</td>
	</tr>
	
	<tr>
	<td>OPERATOR_x</td>
	</tr>
	
	<tr>
	<td>THRESHOLD_VALUE_x (this is for ABSOLUTE conditions)</td>
	</tr>
	
	<tr>
	<td>Violation Value: OBSERVED_VALUE_x</td>
	</tr>
	
	<tr>
	<td>Incident URL: DEEP_LINK_URL + INCIDENT_ID</td>
	</tr>
	
	</table>
	</td>
	</tr>
	
	<tr>
	<td>SEVERITY</td>
	<td>impact</td>
	<td>Represents the impact of the new Problem. Use the SEVERITY parameter where: ERROR = 1,  WARN = 2, and INFO = 3</td>
	</tr>
	
	<tr>
	<td></td>
	<td>knowledge</td>
	<td>This is either "true" or "false" but for policy violations, leave this as "false".</td>
	</tr>
	
	<tr>
	<td></td>
	<td>known_error</td>
	<td> This is either "true" or "false" but for policy violations, leave this as "true".</td>
	</tr>
	
	<tr>
	<td>PRIORITY</td>
	<td>priority</td>
	<td>This is a value from 1 to 5 where: 1 = Critical, 2 =  High, 3 = Moderate, 4 = Low, 5 = Planning. The PRIORITY parameter will fill this out directly.</td>
	</tr>
	
</table>

2. Install Custom Actions

	To create a Custom Action using ServiceNow, first refer to the *Installing Custom Actions into the Controller* heading [here](http://docs.appdynamics.com/display/PRO12S/Configure+Custom+Notifications#ConfigureCustomNotifications-InstallingCustomActionsontheController) (requires AppDynamics login.)

	The custom.xml file and createServiceNowTicket directory used for this custom notification are located within the ``<Controller Home>/custom/actions/`` directory.

	Place the createServiceNowTicket/ directory (containing params.sh and createServiceNowTicket.sh) along with thecustom.xml file into the \<controller\_install\_dir\>/custom/actions/ directory.

3. Look for the newest created Problem in ServiceNowNow

	When a problem is created through AppDynamics it should look similar to the following screenshots.

	The following is an overview shot of ServiceNow:

![](https://raw2.github.com/Appdynamics/servicenow-alerting-extension/master/snowTicket.png)

The following shows the specifics of the ticket description:

![](https://raw2.github.com/Appdynamics/servicenow-alerting-extension/master/snowTicketDetails.png)

**Note**: Notice that the "assigned to" field has "Beth Anglin" current in place here. This is simply an example name and if properly inserted into the params.sh file it will display whichever file is needed
  

##Contributing

Always feel free to fork and contribute any changes directly via [GitHub](https://github.com/Appdynamics/servicenow-alerting-extension).

##Community

Find out more in the [AppSphere](http://appsphere.appdynamics.com/t5/Extensions/ServiceNow-Alerting-Extension/idi-p/751) community.

##Support

For any questions or feature request, please contact [AppDynamics Center of Excellence](mailto:ace-request@appdynamics.com).
