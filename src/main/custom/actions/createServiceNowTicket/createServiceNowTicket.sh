#!/bin/bash

## If you are using the Calgary release, before making this work you must activate JSON Web Service Plugin in ServiceNow
## System Definition > Plugins > Search for 'JSON' > right click on JSON Web Service and click 'Activate/Upgrade'
## If you are using the Dublin release, no action is necessary since the JSON Web Service Plugin is activated by default.

## Import external parameters
. ./params.sh

## Create full domain
if [ "$SERVICENOW_VERSION" = "Dublin" ]; then
	FULL_DOMAIN=$DOMAIN"""/imp_ppd_problem.do?JSONv2&sysparm_action=insert"
else
	FULL_DOMAIN=$DOMAIN"""/imp_ppd_problem.do?JSON&sysparm_action=insert"
fi

## POLICY VIOLATION VARIABLES
APP_NAME="${1//\"/}"
APP_ID="${2//\"/}"
PVN_ALERT_TIME="${3//\"/}"
PRIORITY="${4//\"/}"
SEVERITY="${5//\"/}"
TAG="${6//\"/}"
POLICY_NAME="${7//\"/}"
POLICY_ID="${8//\"/}"
PVN_TIME_PERIOD_IN_MINUTES="${9//\"/}"
AFFECTED_ENTITY_TYPE="${10//\"/}"
AFFECTED_ENTITY_NAME="${11//\"/}"
AFFECTED_ENTITY_ID="${12//\"/}"
NUMBER_OF_EVALUATION_ENTITIES="${13//\"/}"


## Loop through all evaluation entity variables
## Reissue SEVERITY Variable
if [ "$SEVERITY" = "ERROR" ]; then
    SEVERITY=1
elif [ "$SEVERITY" = "WARN" ]; then
    SEVERITY=2
elif [ "$SEVERITY" = "INFO" ]; then
    SEVERITY=3
fi

## Summary Variable
SUMMARY="Application Name: $APP_NAME\n
Policy Violation Alert Time: $PVN_ALERT_TIME\n
Severity: $SEVERITY\n
Name of Violated Policy: $POLICY_NAME\n
Affected Entity Type: $AFFECTED_ENTITY_TYPE\n
Name of Affected Entity: $AFFECTED_ENTITY_NAME\n\n"

## Current Parameter Location
CURP=13
for i in `seq 1 $NUMBER_OF_EVALUATION_ENTITIES`
do
    SUMMARY=$SUMMARY"""EVALUATION ENTITY #"""$i""":\n"

    ((CURP = 1 + $CURP))
    EVALUATION_ENTITY_TYPE="${!CURP}"
    EVALUATION_ENTITY_TYPE="${EVALUATION_ENTITY_TYPE//\"/}"

    SUMMARY=$SUMMARY"""Evaluation Entity: """$EVALUATION_ENTITY_TYPE"""\n"

    ((TCURP = $CURP+$NUMBER_OF_EVALUATION_ENTITIES))
    EVALUATION_ENTITY_NAME="${!TCURP}"
    EVALUATION_ENTITY_NAME="${EVALUATION_ENTITY_NAME//\"/}"
    
    SUMMARY=$SUMMARY"""Evaluation Entity Name: """$EVALUATION_ENTITY_NAME"""\n"

    ((TCURP = $TCURP+$NUMBER_OF_EVALUATION_ENTITIES))
    EVALUATION_ENTITY_ID="${!TCURP}"
    EVALUATION_ENTITY_ID="${EVALUATION_ENTITY_ID//\"/}"
    
    ((TCURP = $TCURP+$NUMBER_OF_EVALUATION_ENTITIES))
    NUMBER_OF_TRIGGERED_CONDITIONS_PER_EVALUATION_ENTITY="${!TCURP}"
    NUMBER_OF_TRIGGERED_CONDITIONS_PER_EVALUATION_ENTITY="${NUMBER_OF_TRIGGERED_CONDITIONS_PER_EVALUATION_ENTITY//\"/}"


    ## GET VARIABLES OF TRIGGERED CONDITIONS
    for trig in `seq 1 $NUMBER_OF_TRIGGERED_CONDITIONS_PER_EVALUATION_ENTITY`
    do

        SUMMARY=$SUMMARY"""\n  Triggered Condition #"""$trig""":\n\n"

        ((TCURP = 1 + $TCURP))
	SCOPE_TYPE_x="${!TCURP}"
	SCOPE_TYPE_x="${SCOPE_TYPE_x//\"/}"
        
        SUMMARY=$SUMMARY"""  Scope Type: """$SCOPE_TYPE_x"""\n"

        ((TCURP = 1 + $TCURP))
	SCOPE_NAME_x="${!TCURP}"
	SCOPE_NAME_x="${SCOPE_NAME_x//\"/}"
        
	SUMMARY=$SUMMARY"""  Scope Name: """$SCOPE_NAME_x"""\n"

        ((TCURP = 1 + $TCURP))
	SCOPE_ID_x="${!TCURP}"
	SCOPE_ID_x="${SCOPE_ID_x//\"/}"

        ((TCURP = 1 + $TCURP))
	CONDITION_NAME_x="${!TCURP}"
	CONDITION_NAME_x="${CONDITION_NAME_x//\"/}"

        ((TCURP = 1 + $TCURP))
	CONDITION_ID_x="${!TCURP}"
	CONDITION_ID_x="${CONDITION_ID_x//\"/}"


        ((TCURP = 1 + $TCURP))
	OPERATOR_x="${!TCURP}"
	OPERATOR_x="${OPERATOR_x//\"/}"

	if [ "$OPERATOR_x" = "LESS_THAN" ]; then
	    OPERATOR_x="<"
	elif [ "$OPERATOR_x" = "LESS_THAN_EQUALS" ]; then
	    OPERATOR_x="<="
	elif [ "$OPERATOR_x" = "GREATER_THAN" ]; then
	    OPERATOR_x=">"
	elif [ "$OPERATOR_x" = "GREATER_THAN_EQUALS" ]; then
	    OPERATOR_x=">="
	elif [ "$OPERATOR_x" = "EQUALS" ]; then
	    OPERATOR_x="=="
	elif [ "$OPERATOR" = "NOT_EQUALS" ]; then
	    OPERATOR_x="!="
        fi 

        ((TCURP = 1 + $TCURP))
	CONDITION_UNIT_TYPE_x="${!TCURP}"
	CONDITION_UNIT_TYPE_x="${CONDITION_UNIT_TYPE_x//\"/}"


        ISBASELINE=${CONDITION_UNIT_TYPE_x:0:8}

	if [ "$ISBASELINE" == "BASELINE_" ]
  	  then
            ((TCURP = 1 + $TCURP))
	    USE_DEFAULT_BASELINE_x="${!TCURP}"
	    USE_DEFAULT_BASELINE_x="${USE_DEFAULT_BASELINE_x//\"/}"
	    SUMMARY=$SUMMARY"""  Is Default Baseline? """$USE_DEFAULT_BASELINE_x"""\n"


            ((TCURP = 1 + $TCURP))
	    BASELINE_NAME_x="${!TCURP}"
	    BASELINE_NAME_x="${BASELINE_NAME_x//\"/}"
	    SUMMARY=$SUMMARY"""  Baseline Name: """$BASELINE_NAME_x"""\n"

            ((TCURP = 1 + $TCURP))
	    BASELINE_ID_x="${!TCURP}"
	    BASELINE_ID_x="${BASELINE_ID_x//\"/}"
	fi

        ((TCURP = 1 + $TCURP))
	THRESHOLD_VALUE_x="${!TCURP}"
	THRESHOLD_VALUE_x="${THRESHOLD_VALUE_x//\"/}"

	SUMMARY=$SUMMARY"""  """$CONDITION_NAME_x""" """$OPERATOR_x""" """$THRESHOLD_VALUE_x"""\n"

        ((TCURP = 1 + $TCURP))
	OBSERVED_VALUE_x="${!TCURP}"
	OBSERVED_VALUE_x="${OBSERVED_VALUE_x//\"/}"

	SUMMARY=$SUMMARY"""  Violation Value: """$OBSERVED_VALUE_x"""\n"

    done
done

((CURP=$TCURP))

((CURP=1+$CURP))
SUMMARY_MESSAGE="${!CURP}"
SUMMARY_MESSAGE="${SUMMARY_MESSAGE//\"/}"

((CURP = 1 + $CURP))
INCIDENT_ID="${!CURP}"
INCIDENT_ID="${INCIDENT_ID//\"/}"

((CURP = 1 + $CURP))
DEEP_LINK_URL="${!CURP}"
DEEP_LINK_URL="${DEEP_LINK_URL//\"/}"

SUMMARY=$SUMMARY"""\nIncident URL: """$DEEP_LINK_URL""$INCIDENT_ID"""\n"

## CURL request to create a new Problem in ServiceNow with the generated Violated Policy Parameters
## instead of demo11 insert your own domain for ServiceNow
CONTENT_TYPE=""
if [ "$SERVICENOW_VERSION" = "Dublin" ]; then
	CONTENT_TYPE=" -H """Content-type:application/json""""
fi
curl --user $USER:$PASS $CONTENT_TYPE -XPOST $FULL_DOMAIN -d '{
    "assigned_to" : "'"$ASSIGN_TO"'",
    "knowledge" : "false",
    "known_error" : "false",
    "priority" : "'"$PRIORITY"'",
    "impact" : "'"$SEVERITY"'",
    "short_description" : "'"$POLICY_NAME"'",
    "description" : "'"$SUMMARY"'"
}' | python -mjson.tool 

## Incident CURL call - currently not in use
: << "EXIT"
#curl --user admin:admin -XPOST 'https://demo11.service-now.com/incident.do?JSON&sysparm_action=insert' -d '{
#    "assignment_group" : "Capacity Mgmt",
#    "assigned_to" : "Don Goodliffe",
#    "caller_id" : "acme.employee@yourcompany.com",
#    "category" : "request",
#    "short_description" : "Policy Violated - View more details inside",
#    "description" : "TEST DESCRIPTION",
#    "company" : "ACME",
#    "work_notes" : "'"$SUMMARY_MESSAGE"' \n test",
#    "location" : "San Francisco"
#}' | python -mjson.tool >> jsonoutput
EXIT
