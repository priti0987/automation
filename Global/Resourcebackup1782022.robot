*** Settings ***
Library     RequestsLibrary
Library     Dialogs
Library     os
Library     JSONLibrary
Library     Collections
Library     C:/STS_API_Automation/excel_1.py
Library    DateTime
Resource    ../testAPI.robot

*** Variables ***
${dataFile}                  TestData/TestData.xlsx
${datasheetLogin}            Login
${DataSheetEditDashBoard}    DataSheetEditDashBoard
${API_Base_Endpoint_Sheet}   API_Base_Endpoint

*** Variables ***
${API_Base_Endpoint}


*** Keywords ***
get API Values
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    Set Global Variable       ${API_Base_Endpoint}
I Create Post Request For Login And Verify Response
    get API Values
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    2    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    2    4
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    6
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    2    7
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=                  convert to string                   ${response.status_code}
    should be equal         ${id}         200
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    END

I Create Post Request For Send Sms And Verify Response
    log     I send sms
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    3    2
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    3    6
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2   10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     headers=${header}
    log    ${response.status_code}
    #verification
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    log          ${id}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Code sent']

I Create Post Request For Verification Of 2FA Code And Verify Reponse
    log     verification check and verify 2FA
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Login    4    2
    ${CodeFromUser}=        get value from user     2FA Code
    ${End_Points}=         Set Variable     ${End_Points}${CodeFromUser}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200



I Create Get Request For SSI Dashboard And Verify Response
    log     I verify dashboard
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    5    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']

I Create Post Request For Login With Limited User And Verify Response
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    8    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    8    4
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    6
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    2    7
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string      ${id}
    should be equal         ${id}         [200]
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    END

I Create Get Request For Dashboard With GetUserNewAssignedCompany And Verify Response
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    6    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']


I Create Post Request For Login With User And Verify Response
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    9    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    9    4
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    7
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    2    8
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}      Email=${Email}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    END

I Create Post Request For Login With Company Admin And Verify Response
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    10    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    10    4
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    6
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    2    8
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    log          ${id}
    should be equal         ${id}         200
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    END

I Create Post Request For Login With Company Manager And Verify Response
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    11    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    11    4
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    7
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    2    8
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}      Email=${Email}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    END


I Create Post Request Edit DashBoard Widgets
    [Arguments]         ${AccountRole}
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    7
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    4
    ${EventPage}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    5
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    8
    ${EventName}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    9
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    10
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}     Email=${Email}      EventPage=${EventPage}      EventPageUrl=${EventPageUrl}    EventName=${EventName}   EventDescription=${EventDescription}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Successfully to Save to Database']

I Create Post Request Arrange Widgets
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    7
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    4
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${WidgetOrderIds}=          Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    11
    ${WidgetOrderIds}=          Create list    ${WidgetOrderIds}
    ${WidgetsLocation}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    12
    ${WidgetsLocation}=         Create list      ${WidgetsLocation}
    ${WidgetsIds}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    13
    ${WidgetsIds}=              Create list       ${WidgetsIds}
    ${StartDates}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    14
    ${EndDates}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    15
    ${Regions}=                 Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    16
    ${IsDateSearches}=          Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    17
    ${StartDates}=              Convert Date      ${StartDates}
    ${StartDates}=              Create list      ${StartDates}
    ${EndDates}=                Convert Date       ${EndDates}
    ${EndDates}=                Create list       ${EndDates}
    ${Regions}=                 Create list   ${Regions}
    ${IsDateSearches}=          Create list       ${IsDateSearches}
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=                    create dictionary      Email=${Email}      WidgetOrderIds=${WidgetOrderIds}    WidgetsLocation=${WidgetsLocation}      WidgetsIds=${WidgetsIds}    StartDates=${StartDates}    EndDates=${EndDates}    Regions=${Regions}  IsDateSearches=${IsDateSearches}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=                post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${JsonObj}=                 to json     ${response.content}
    ${id}=                      Get value from json        ${JsonObj}       $.statusCode
    ${id}=                      convert to string                   ${response.status_code}
    should be equal             ${id}         200
    should be equal             ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                 Get value from json        ${JsonObj}       $.message
    ${message}=                 convert to string                   ${message}
    should be equal             ${message}         ['Success. ']


I Create Get Request For Get User Widget For verification
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    4    3
    ${Cookie}=             Get Cell Value    ${dataFile}    ${datasheetLogin}    2    9
    ${Cookie}=             Set Variable      .AspNetCore.Session=${Cookie}
    create session         API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=      convert to string                   ${response.status_code}
    should be equal        ${StrinfResCode}      200
    ${JsonObj}=            to json           ${response.content}
    ${id}=                 Get value from json        ${JsonObj}       $.statusCode
    ${WidgetsIds}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    13
    ${WidgetsIds}=         Create list       ${WidgetsIds}
    ${id}=                 convert to string      ${response.status_code}
    should be equal        ${id}             200
    ${message}=            Get value from json        ${JsonObj}       $.message
    ${message}=            convert to string                   ${message}
    should be equal        ${message}        ['Success. ']
    ${WID}=                Get value from json        ${JsonObj}       $.result[0].widgetsId
    Should Be Equal        ${WID}     ${WidgetsIds}

I Create Post Request Refresh DashBoard Widgets
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    7
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    4
    ${EventPage}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    5
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable      .AspNetCore.Session=${Cookie}
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    8
    ${EventName}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    5    9
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    5    10
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=                    create dictionary      Username=${Username}     Email=${Email}      EventPage=${EventPage}      EventPageUrl=${EventPageUrl}    EventName=${EventName}   EventDescription=${EventDescription}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=                post request      API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${JsonObj}=                 to json           ${response.content}
    ${id}=                      Get value from json        ${JsonObj}       $.statusCode
    ${id}=                      convert to string                   ${response.status_code}
    should be equal             ${id}              200
    should be equal             ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                 Get value from json        ${JsonObj}       $.message
    ${message}=                 convert to string                   ${message}
    should be equal             ${message}         ['Successfully to Save to Database']

I Create Get Request For Company Admin Dashboard And Verify Response
    log     I verify dashboard
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    10    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']

I Create Get Request For Company Manager Dashboard And Verify Response
    log     I verify dashboard
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    11    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']

I Create Get Request For User Dashboard And Verify Response
    log     I verify dashboard
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    9    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']

I Create Post Request Edit DashBoard Widgets For Company Manager
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    7
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    4
    ${EventPage}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    5
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    8
    ${EventName}=               Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    9
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    10
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}     Email=${Email}      EventPage=${EventPage}      EventPageUrl=${EventPageUrl}    EventName=${EventName}   EventDescription=${EventDescription}       UserId=${UserId}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal         ${message}         ['Successfully to Save to Database']

I Create Post Request Arrange Widgets1
    [Arguments]         ${AccountRole}
    log         ${AccountRole}

I Create Get Request For Dashboard And Verify Response1
    [Arguments]         ${AccountRole}
    log      ${AccountRole}
    ${role}=        Set variable    ${AccountRole}
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${API_Base_Endpoint_Sheet}    2    1
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    11    3
    IF   '${role}'=='Company Manager'
    log       'companymanager'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    11    2
    ELSE IF     '${role}'=='SSI'
    log       'ssi'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    5    4
    ELSE IF     '${role}'=='Company Admin'
    log       'Companyadmin'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    10    2
    ELSE IF      '${role}'=='User'
    log       'user'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    9    2
    END
    ${End_Points}=      set variable       ${End_Points}${Email}
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Success. ']
