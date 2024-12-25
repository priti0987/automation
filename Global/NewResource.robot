*** Settings ***
Library   OperatingSystem
Library     RequestsLibrary
Library     Dialogs
Library     os
Library     JSONLibrary
Library     Collections
Library     C:/STS_API_Automation/excel_1.py
Library    DateTime
Library    String
Resource    ../testAPI.robot

*** Variables ***
${dataFile}                  TestData/TestData.xlsx
${datasheetLogin}            Login
${DataSheetEditDashBoard}    DataSheetEditDashBoard
${API_Base_Endpoint_Sheet}   API_Base_Endpoint
${Pages}                     Pages
${SuccessMessage}           ['Successfully to Save to Database']
*** Variables ***
${API_Base_Endpoint}


*** Keywords ***
get API Values
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    Set Global Variable       ${API_Base_Endpoint}

I Create Request For complete an order
    #checkOrderEmailSettings
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    54    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    #Auditrail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=0  Email=carrogancia@contractors.stevensonsystems.com	UserName=carrogancia@contractors.stevensonsystems.com   EventPage=Order Details   EventPageUrl=/order-details/19076  CompanyId=2  EventName=Send Email to Client  EventDescription=carrogancia@contractors.stevensonsystems.com sends email to toni-ann1907619076@ssicorporate.com for Communicate  EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    #UpdateRequestDetails
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    55    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    #${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${headers}=    Create Dictionary    Content-Type=application/json      Cookie=${Cookie}
    ${RequestId}=               Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${body}=            create dictionary         RequestId=${RequestId}	UserId=0	RequestType=unknown	RequestDate=2023-05-24T01:14:18.653	CompletionDate=2023-05-24T21:58:39.3200303-07:00	LastUpdateDate=2023-05-24T21:58:39.320034-07:00	AssignedUser=Tara Finigan   AssignedUserId=3085	AssignedDate=2023-05-24T21:58:19.9929264-07:00	  StartDate=2023-05-24T21:58:39.3200336-07:00	OrderStatus=Completed		requestStatusId=4	SendEmailToClient=true
    ${response}=       post request    API_Testing         ${End_Points}/0          headers=${header}         data=${body}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200

I Create POST Request To download Active Orders
    #GenerateRequestsCsvFile for active
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    56    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    #${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${headers}=    Create Dictionary    Content-Type=application/json      Cookie=${Cookie}
    ${body}=            create dictionary           UserId=0	IsSearch=false	  ShowActive=true	Take=9999	  Skip=0
    ${response}=       post request    API_Testing         ${End_Points}        headers=${headers}         data=${body}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200

    #GenerateRequestsCsvFile for all orders
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    56    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    #${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${headers}=    Create Dictionary    Content-Type=application/json      Cookie=${Cookie}
    ${body}=            create dictionary           UserId=0	IsSearch=false	  ShowActive=false	Take=9999	  Skip=0
    ${response}=       post request    API_Testing         ${End_Points}        headers=${headers}         data=${body}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200

