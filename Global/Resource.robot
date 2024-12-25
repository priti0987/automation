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

I Create Post Request For Send Sms And Verify Response
    get API Values
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    3    2
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    3    6
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2   10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     headers=${header}
    #verification
    should be equal     ${response.status_code}     ${ExpectedStatus_code}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['Code sent']

I Create Post Request For Verification Of 2FA Code And Verify Reponse
    get API Values
    ${End_Points}=         Get Cell Value    ${dataFile}    Login    4    2
    ${CodeFromUser}=        get value from user     2FA Code
    ${End_Points}=         Set Variable     ${End_Points}${CodeFromUser}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         200



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




I Create Post Request For Login And Verify Response
    [Arguments]         ${AccountRole}
    ${role}=        Set variable    ${AccountRole}
    get API Values
    ${End_Points}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    2
    IF   '${role}'=='Company Manager'
    ${row}=        Set Variable     11
    ELSE IF     '${role}'=='SSIEmployee'
    ${row}=        Set Variable     12
    ELSE IF     '${role}'=='SSI'
    ${row}=        Set Variable     7
    ELSE IF     '${role}'=='Company Admin'
    ${row}=        Set Variable     10
    ELSE IF      '${role}'=='User'
    ${row}=        Set Variable     9
    ELSE IF      '${role}'=='Limited User'
    ${row}=        Set Variable     8
    END
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    ${row}    3
    ${Password}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    ${row}    4
    ${Username}=           encode_my_Data       ${Username}
    ${Password}=           encode_my_Data       ${Password}
    ${ExpectedStatus_code}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    2    7
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}
    ${header}=          create dictionary       Content-type=application/json,
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #verification
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${id}
    should be equal         ${id}         [200]
    ${message}=                  Get value from json        ${JsonObj}       $.message
    #{message}=      convert to string                   ${message}
    #should be equal         ${message}         ['Success']
    FOR     ${P}     IN     @{response.cookies}
    write data      ${dataFile}     ${datasheetLogin}    2    10   ${P.value}
    Exit For Loop
    END

I Create Post Request Arrange Widgets
    [Arguments]         ${AccountRole}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${role}=        Set variable    ${AccountRole}
    IF   '${role}'=='Company Manager'
    ${API_Base_Endpoint}=       Set variable    https://qa-experienceboardapi.truspace.com/
    ${row}=      Set Variable       9
    ELSE IF     '${role}'=='SSI'
    ${row}=      Set Variable       6
    ELSE IF     '${role}'=='Company Admin'
    ${row}=      Set Variable       8
    ELSE IF      '${role}'=='User'
    ${row}=      Set Variable       7
    ELSE IF      '${role}'=='SSIEmployee'
    ${row}=      Set Variable       10

    END

    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    4
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    3
    ${WidgetOrderIds}=          Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    11
    ${WidgetsLocation}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    12
    ${WidgetsIds}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    13
    ${StartDates}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    14
    ${EndDates}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    15
    ${Regions}=                 Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    16
    ${IsDateSearches}=          Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    ${row}    17
    ${StartDates}=              Convert Date      ${StartDates}
    ${StartDates}=              Create list      ${StartDates}
    ${EndDates}=                Convert Date       ${EndDates}
    ${EndDates}=                Create list       ${EndDates}
    ${Regions}=                 Convert To String    ${Regions}
    ${Regions}=                 Create list          ${Regions}
    ${IsDateSearches}=          Create list          ${IsDateSearches}
    ${WidgetOrderIds}=          Create list          ${WidgetOrderIds}
    ${WidgetsLocation}=         Create list          ${WidgetsLocation}
    ${WidgetsIds}=              Create list       ${WidgetsIds}
    create session              API_Testing       https://qa-experienceboardapi.truspace.com
    ${body}=                    create dictionary      Email=${Email}      WidgetOrderIds=${WidgetOrderIds}    WidgetsLocation=${WidgetsLocation}      WidgetsIds=${WidgetsIds}    StartDates=${StartDates}    EndDates=${EndDates}    Regions=${Regions}  IsDateSearches=${IsDateSearches}         UserId=${UserId}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=                post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #${JsonObj}=                 to json     ${response.content}
    #${id}=                      Get value from json        ${JsonObj}       $.statusCode
    #${id}=                      convert to string                   ${response.status_code}
    #should be equal             ${response.status}         201
    #${message}=                 Get value from json        ${JsonObj}       $.message
    #${message}=                 convert to string                   ${message}
    #should be equal             ${message}         ['Success. ']
    log     ${response}
    Should Be Equal As Strings    ${response}    <Response [201]>


I Create Get Request For Get User Widget For verification
    [Arguments]         ${AccountRole}
    ${role}=        Set variable    ${AccountRole}
    ${End_Points}=          Get Cell Value      ${dataFile}    ${DataSheetEditDashBoard}    4    3
    ${WidgetID_Given}=      Get Cell Value      ${dataFile}    ${DataSheetEditDashBoard}    2   18
    ${Cookie}=              Get Cell Value      ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=             Set Variable      .AspNetCore.Session=${Cookie}
    IF   '${role}'=='Company Manager'
    ${Email}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    4
    ELSE IF     '${role}'=='SSI'
    ${Email}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    4
    ELSE IF                '${role}'=='Company Admin'
    ${Email}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    4
    ELSE IF                '${role}'=='User'
    ${Email}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    7    4
    ELSE IF                '${role}'=='SSIEmployee'
    ${Email}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    10    4

    END
    ${End_Points}=         Set Variable     ${End_Points}${WidgetID_Given}/${Email}
    create session         API_Testing      ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=      convert to string                   ${response.status_code}
    should be equal        ${StrinfResCode}      200
    ${JsonObj}=            to json           ${response.content}
    ${id}=                 Get value from json        ${JsonObj}       $.statusCode
    ${id}=                 convert to string      ${response.status_code}
    should be equal        ${id}             200
    ${message}=            Get value from json        ${JsonObj}       $.message
    ${message}=            convert to string                   ${message}
    should be equal        ${message}        ['Success. ']
    IF          '${role}'=='Company Manager'
    ${row}=      Set Variable       9
    ELSE IF     '${role}'=='SSI'
    ${row}=      Set Variable       6
    ELSE IF     '${role}'=='SSIEmployee'
    ${row}=      Set Variable       10
    ELSE IF      '${role}'=='Company Admin'
    ${row}=       Set Variable      8
    ELSE IF       '${role}'=='User'
    ${row}=       Set Variable      7
    END
    ${W1}=      Get value from json        ${JsonObj}       $.result[${WidgetID_Given}].widgetsId
    ${W1}=      Get From List    ${W1}    0
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    13    ${W1}
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].widgetsOrderId
    ${W1}=          Get From List    ${W1}    0
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    11    ${W1}
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].widgetsLocation
    ${W1}=          Get From List    ${W1}    0
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    12   ${W1}
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].startDate
    ${W1}=          convert to string           ${W1}
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    14   ${W1}
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].endDate
    ${W1}=          convert to string           ${W1}
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    15   ${W1}
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].region
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    16       ${W1}[0]
    ${W1}=          Get value from json        ${JsonObj}    $.result[${WidgetID_Given}].isDateSearch
    ${W1}=          Get From List    ${W1}    0
    write data      ${dataFile}     ${DataSheetEditDashBoard}    ${row}    17       ${W1}


I Create Post Request Navigation on Dashboard
    [Arguments]         ${AccountRole}      ${Page}
    ${role}=        Set variable    ${AccountRole}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    2    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    IF   '${Page}'=='Edit'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    2    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    2    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    2    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    2    5
    ELSE IF         '${Page}'=='Refresh'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    3    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    3    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    3    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    3    5
    ELSE IF         '${Page}'=='Properties'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    4    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    4    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    4    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    4    5
    ELSE IF         '${Page}'=='FilterByCompany'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    5    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    5    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    5    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    5    5
    ELSE IF         '${Page}'=='SearchBuildings'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    6    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    6    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    6    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    6    5
    ELSE IF         '${Page}'=='SpecialCharacter'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    7    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    7    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    7    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    7    5
    ${SearchText}=              Get Cell Value    ${dataFile}    ${Pages}    7    6
    ELSE IF         '${Page}'=='CreateOrder'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    10    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    10    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    10    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    10    5
    ELSE IF         '${Page}'=='ReportView'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    11    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    11    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    11    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    11    5
    ELSE IF         '${Page}'=='ViewAllOrders'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    12    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    12    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    12    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    12    5
    ELSE IF         '${Page}'=='Property Summary'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    15    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    15    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    15    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    15    5
    ${BuildingId}=              Get Cell Value    ${dataFile}    ${Pages}    6    8
    ${EventPageUrl}=        Set Variable      ${EventPageUrl}${BuildingId}
    ELSE IF         '${Page}'=='Tenant Details'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    13    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    13    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    13    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    13    5
    ${BuildingId}=              Get Cell Value    ${dataFile}    ${Pages}    6    8
    ${EventPageUrl}=        Set Variable      ${EventPageUrl}${BuildingId}
    ELSE IF         '${Page}'=='Stacking Plan'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    18    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    18    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    18    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    18    5
    ${BuildingId}=              Get Cell Value    ${dataFile}    ${Pages}    6    8
    ${EventPageUrl}=        Set Variable      ${EventPageUrl}${BuildingId}
    ELSE IF         '${Page}'=='Drawing vault'
    ${EventPage}=               Get Cell Value    ${dataFile}    ${Pages}    20    2
    ${EventPageUrl}=            Get Cell Value    ${dataFile}    ${Pages}    20    3
    ${EventName}=               Get Cell Value    ${dataFile}    ${Pages}    20    4
    ${EventDescription}=        Get Cell Value    ${dataFile}    ${Pages}    20    5
    ${BuildingId}=              Get Cell Value    ${dataFile}    ${Pages}    6    8
    ${EventPageUrl}=        Set Variable      ${EventPageUrl}${BuildingId}
    END
    ${SearchText}=              Set Variable       600 Casterly Rock

    IF   '${role}'=='Company Manager'
    log       'companymanager'
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    4
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    ELSE IF     '${role}'=='SSI'
    ${Email}=                   Get Cell Value    ${dataFile}    ${datasheetLogin}    2    3
    ${Username}=                Get Cell Value    ${dataFile}    ${datasheetLogin}    2    3
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    6    3
    ELSE IF     '${role}'=='Company Admin'
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    4
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ELSE IF      '${role}'=='Limited User'
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    8    7
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    8    7
    ${UserId}=             Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    12    3
    ${SearchText}=              Set Variable       1235

    ELSE IF      '${role}'=='User'
    ${Email}=                   Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    7    4
    ${Username}=                Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    7    4
    ${UserId}=                  Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    7    3
    ELSE IF      '${role}'=='SSIEmployee'
    ${Email}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    12    7
    ${Username}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    7
    ${UserId}=             Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    10    3
    END
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}     Email=${Email}      EventPage=${EventPage}      EventPageUrl=${EventPageUrl}    EventName=${EventName}   EventDescription=${EventDescription}       UserId=${UserId}
    IF         '${Page}'=='SearchBuildings'
    ${body}=            create dictionary      SearchText=${SearchText}     Take=30      UserId=${UserId}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    6    7
    ${SuccessMessage}=          Set Variable        ['OK']
    END
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    #${JsonObj}=             to json     ${response.content}
    #${id}=                  Get value from json        ${JsonObj}       $.statusCode
    #${id}=      convert to string                   ${response.status_code}
    #should be equal         ${id}         200
    #should be equal     ${response.status_code}     ${ExpectedStatus_code}
    #${message}=         Get value from json        ${JsonObj}       $.message
    #${message}=         convert to string                   ${message}
    #should be equal         ${message}         ${SuccessMessage}
    IF   '${role}'!='Limited User'
    IF      '${role}'!='User'
    IF         '${Page}'=='SearchBuildings'
    ${JsonObj}=             to json     ${response.content}
    ${message}=         Get value from json        ${JsonObj}          $.result[0].buildingsId
    ${W1}=    Get From List    ${message}    0
    write data      ${dataFile}     ${Pages}    6    8       ${W1}
    ${message1}=         Get value from json        ${JsonObj}          $.result[0].loadFactor
    ${W1}=    Get From List    ${message1}    0
    ${type string}=    Evaluate     type(${W1})
    Should Be Equal As Strings    ${type string}    <class 'float'>
    END
    END
    END



I Create Get Request For Dashboard And Verify Response
    [Arguments]         ${AccountRole}
    ${role}=        Set variable    ${AccountRole}
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    11    3
    IF   '${role}'=='Company Manager'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    11    2
    ELSE IF     '${role}'=='SSI'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    5    4
    ELSE IF     '${role}'=='Company Admin'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    10    2
    ELSE IF      '${role}'=='User'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    9    2
    ELSE IF      '${role}'=='SSIEmployee'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    7
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

I Create Get Request For Dashboard Session And Verify Response
    ${End_Points}=         Get Cell Value    ${dataFile}    Sheet7    3    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}


I Create Post Request Annotate On The PDF
    [Arguments]         ${AccountRole}
    IF   '${AccountRole}'=='Company Manager'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    11    2
    ELSE IF     '${AccountRole}'=='SSI'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    5    4
    log         SSIadmin
    ELSE IF     '${AccountRole}'=='Company Admin'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    10    2
    ELSE IF      '${AccountRole}'=='User'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    9    2
    ELSE IF      '${AccountRole}'=='SSIEmployee'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    7
    END
    ${End_Points}=              Get Cell Value    ${dataFile}    ${datasheetLogin}    14    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}

    create session              API_Testing       ${API_Base_Endpoint}
    ${number}=          Convert To Integer    6
    ${number}=          Set Variable        ${number}
    ${body}=                    create dictionary      type=${number}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=                post request        API_Testing         ${End_Points}     data=${body}        headers=${header}



I Create Post Request For Add Property And Verify
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    14    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}

    create session              API_Testing       ${API_Base_Endpoint}
    ${BuildingTypeId}=          Convert To Integer    1
    ${BuildingTypeId}=          Set Variable        ${BuildingTypeId}
    ${OwnerId}=                 Convert To Integer      3887
    ${Name}=                    Generate Random String      6
    ${Name}=                    Set Variable    Test_${Name}_Name
    ${Address}=                 Generate Random String      6
    ${Address}=                 Set Variable    ${Address}_Address
    ${BldgNum}=                 Generate Random String      6
    ${BldgNum}=                 Set Variable    ${BldgNum}_BldgNum
    ${City}=                    Generate Random String      6
    ${City}=                    Set Variable    ${City}_City
    ${State}=                   Generate Random String      6
    ${State}=                   Set Variable     ${State}_State
    ${RandomZip}=               Generate Random String      6       12345678
    ${Zip}=                     Convert To Integer    ${RandomZip}
    ${body}=                    create dictionary      BuildingTypeId=${BuildingTypeId}         Zip=${Zip}              OwnerId=${OwnerId}    Name=${Name}    Address=${Address}      BldgNum=${BldgNum}      City=${City}    State=${State}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=                post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=                  Get value from json        ${JsonObj}       $.result.zip
    ${message}=      convert to string                   ${message}
    should be equal     ${message}        ['${RandomZip}']

I Create Post Request To View Report Statuses And Verify Response
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    16    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    ${message}=      convert to string          ${message}
    Should Be Equal As Strings    ${message}    ['Success. ']


I Create Post Request To View Report Update features And Verify Response
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    17    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}


I create Get Request for View Notification
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}       19      3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}

I Create Get Request For Get Session Value
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}       8      3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}; remember-me-pritibhushanf@gmail.com=cHJpdGliaHVzaGFuZkBnbWFpbC5jb20xMDMuMjUwLjE1MC4xNw==
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}


I Create Get Request For Get User Id
    [Arguments]         ${AccountRole}
    #Login to ssi admin
    I Create Post Request For Login And Verify Response        SSI
    #POST LoadAllUsers and search comp manager email id
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    31    2
    IF   '${AccountRole}'=='Company Manager'
    ${row1}=        Set Variable            9
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    11    2
    ELSE IF     '${AccountRole}'=='Company Admin'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    10    2
    ${row1}=        Set Variable            8
    ELSE IF     '${AccountRole}'=='Limited User'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    8    2
    ${row1}=        Set Variable            12
    ELSE IF      '${AccountRole}'=='User'
    ${Email}=           Get Cell Value    ${dataFile}    Sheet7    9    2
    ELSE IF      '${AccountRole}'=='SSIEmployee'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    7
    END
    ${body}=               create dictionary     Take=10    	CompanyId=0  	UserId=0	Role=SSI Administrator	  SearchText=${Email}	  IsSearch=true
    ${Cookie}=             Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=             Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=            to json     ${response.content}
    ${body}=               Get value from json        ${JsonObj}       $.result[0].userId
    ${body}=               Get From List    ${body}     0
    write data             ${dataFile}     ${DataSheetEditDashBoard}    ${row1}    3       ${body}


I Create Get Request For Get User Id Value For
    [Arguments]         ${AccountRole}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}       21      3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=            to json     ${response.content}
    @{body}=                Get value from json        ${JsonObj}       $.result
    #${b}=                Get Length        @{body}
    ${index}=           Set Variable        0
    ${index}=       Convert To Integer    ${index}
    #${body_lst}=               Get value from json        ${JsonObj}       $.result[${index}].userId
    ${body}=               Get value from json        ${JsonObj}       $.result[${index}].userId
    ${body}=               Get From List    ${body}     0
    ${body}=        Convert To Integer       ${body}
    ${body}=        Convert To Integer       ${body}
    ${one}=         Set Variable            1
    ${one}=         Convert To Integer      ${one}
    ${uIID_}=       Evaluate            ${body}+${one}
    write data             ${dataFile}     ${DataSheetEditDashBoard}    8    3       ${uIID_}

I Create Get Request For Validation Of SearchBuildings In SSI
    #I ENABLE REPORT
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    6    3
    ${End_Points}=         Get Cell Value   ${dataFile}  ${Pages}       6        7
    ${SearchText}=         Set Variable       600 Casterly Rock
    ${body}=               create dictionary      SearchText=${SearchText}     Take=30      UserId=${UserId}      Filter=Address
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=          Get value from json        ${JsonObj}       $.message
    ${buildingsId}=      Get value from json        ${JsonObj}       $.result[0].buildingsId
    ${buildingsId}=      Get From List    ${buildingsId}    0
    write data             ${dataFile}     PropertyListing    11    2           ${buildingsId}
    ${name}=             Get value from json        ${JsonObj}       $.result[0].name
    ${Actual_name}=      Get From List    ${name}    0
    ${Actual_name}=      Convert To String    ${Actual_name}
    ${Expected_name}=    Get Cell Value    ${dataFile}    PropertyListing    8    2
    should be equal     ${Actual_name}      ${Expected_name}
    ${clientRsf}    Get value from json        ${JsonObj}       $.result[0].clientRsf
    ${Actual_clientRsf}=          Get From List    ${clientRsf}    0
    ${Actual_clientRsf}=    Convert To String    ${Actual_clientRsf}
    ${Expected_clientRsf}=    Get Cell Value    ${dataFile}    PropertyListing    2    2
    # should be equal     ${Actual_clientRsf}     ${Expected_clientRsf}
    ${stevensonRsf}    Get value from json        ${JsonObj}       $.result[0].stevensonRsf
    ${Actual_stevensonRsf}=          Get From List    ${stevensonRsf}    0
    ${Actual_stevensonRsf}=         Convert To String       ${Actual_stevensonRsf}
    ${Expected_stevensonRsf}=    Get Cell Value    ${dataFile}    PropertyListing    3    2
    #should be equal         ${Actual_stevensonRsf}      ${Expected_stevensonRsf}
    ${loadFactor}    Get value from json        ${JsonObj}       $.result[0].loadFactor
    ${Actual_loadFactor}=          Get From List    ${loadFactor}    0
    ${Actual_loadFactor}=       Convert To String    ${Actual_loadFactor}
    ${Expected_loadFactor}=    Get Cell Value    ${dataFile}    PropertyListing    4    2
    ${Expected_loadFactor}=     convert to string       ${Expected_loadFactor}
    #should be equal     ${Actual_loadFactor}        ${Expected_loadFactor}
    ${opportunityRsf}    Get value from json        ${JsonObj}       $.result[0].opportunityRsf
    ${Actual_opportunityRsf}=          Get From List    ${opportunityRsf}    0
    ${Actual_opportunityRsf}=       Convert To String    ${Actual_opportunityRsf}
    ${Expected_opportunityRsf}=    Get Cell Value    ${dataFile}    PropertyListing    5    2
    #should be equal     ${Actual_opportunityRsf}        ${Expected_opportunityRsf}
    ${currentClientRsf}    Get value from json        ${JsonObj}       $.result[0].currentClientRsf
    ${Actual_currentClientRsf}=          Get From List    ${currentClientRsf}    0
    ${Actual_currentClientRsf}=     Convert To String    ${Actual_currentClientRsf}
    ${Expected_currentClientRsf}=    Get Cell Value    ${dataFile}    PropertyListing    6    2
    #should be equal     ${Actual_currentClientRsf}      ${Expected_currentClientRsf}
    ${currentOpportunityRsf}=       Get value from json        ${JsonObj}       $.result[0].currentOpportunityRsf
    ${Actual_currentOpportunityRsf}=          Get From List    ${currentOpportunityRsf}    0
    ${Actual_currentOpportunityRsf}=        Convert To String    ${Actual_currentOpportunityRsf}
    ${Expected_currentOpportunityRsf}=    Get Cell Value    ${dataFile}    PropertyListing    7    2
    #should be equal     ${Actual_currentOpportunityRsf}     ${Expected_currentOpportunityRsf}
    ${propertyLinkDetail}=       Get value from json        ${JsonObj}       $.result[0].propertyLinkDetail
    ${reportLink}=              Get value from json        ${JsonObj}       $.result[0].reportLink

I ENABLE REPORT
    ${End_Points}=         Get Cell Value   ${dataFile}   ${Pages}       24        3
    ${BuildingOwners}=      Set variable        1
    ${BuildingOwners}=      Create List         ${BuildingOwners}
    ${body}=               create dictionary      BuildingsId=7632     OwnerId=1486      Address=600 Casterly Rock      BuildingOwners=${BuildingOwners}  CurrentBuildingReportId= 1904    OwnerId= 1486    OwnerCostPerSqft= 250    OwnerCostperSquareFoot= 250    Address= 600 Casterly Rock    City= Anchorage    State= AK    Country= United States    Zip= 48484    Name= 600 Casterly Rock    BldgNum= 600CAS    BuildingTypeId= 1    PropertyManagerId= 1496    BaseRentable= 174137    BaseYear=0     BuildingOwners=${BuildingOwners}    Active= false    SelectedReportId= 1904    SSIReportReviewId= 1904    IsReportActive= true    ReportDate= 2020-11-19    ClientRentable= 354065.35    TotalRentable= 379217.68
    ${Cookie}=             Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=             Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Property Details Updated!']

I Create Get Request For Validation In SSI For
    #I ENABLE REPORT
    [Arguments]         ${FOR}
    ${reportId}=        Set Variable        1904
    ${reportId1}=        Set Variable        1486

    ${buildingsId}=     Get Cell Value    ${dataFile}     PropertyListing    11    2
    IF     '${FOR}'=='GetOwnerDetails'
    ${End_Points}=      Set Variable     /api/companies/GetOwnerDetails/0
    ELSE IF      '${FOR}'=='reportstatuses'
    ${End_Points}=      Set Variable     /api/portfolio/reportstatuses
    ELSE IF      '${FOR}'=='GetInformationIcons'
    ${End_Points}=      Set Variable     /api/account/GetInformationIcons
    ELSE IF      '${FOR}'=='get-building-address'
    ${End_Points}=      Set Variable     /api/portfolio/get-building-address/${buildingsId}

    ELSE IF      '${FOR}'=='LoadSsiUsers'
    ${End_Points}=      Set Variable     /api/account/LoadSsiUsers/

    ELSE IF      '${FOR}'=='standards'
    ${End_Points}=      Set Variable     /api/portfolio/standards

    ELSE IF      '${FOR}'=='propertyDetail'
    ${End_Points}=      Set Variable     /api/portfolio/propertyDetail/0/${buildingsId}/${reportId}

    ELSE IF      '${FOR}'=='company-managers-list'
    ${End_Points}=      Set Variable     /api/account/company-managers-list/${reportId1}

    ELSE IF      '${FOR}'=='GetCompanyRegions'
    ${End_Points}=      Set Variable     /api/companies/GetCompanyRegions/${reportId1}

    ELSE
    ${End_Points}=      Get Cell Value   ${dataFile}   ${Pages}       25        3
    ${End_Points}=      Set Variable    ${End_Points}${FOR}/${buildingsId}
    END
    ${Cookie}=          Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=          Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    #get-building-address-with-company
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=         Get value from json        ${JsonObj}       $.message
    IF                '${FOR}'=='get-building-address-with-company'
    ${Expected_message}=        Set Variable       ['Address Found']
    ${Address}=       Get value from json        ${JsonObj}       $.result.address
    ${Address}=       Get From List         ${Address}      0
    ${Expected_name}=    Get Cell Value    ${dataFile}    PropertyListing    8    2
    Should Contain    ${Address}    ${Expected_name}
    ELSE IF     '${FOR}' == 'get-building-address'
    ${Expected_message}=        Set Variable       ['Address Found']
    ELSE IF      '${FOR}'=='propertyDetail'
    ${Expected_message}=        Set Variable       ['Sucessfully Retrieved Property Details.']
    Should Be Equal As Strings    ${message}    ${Expected_message}
    ${Owner_companyName}=       Get value from json        ${JsonObj}       $.result.companyName
    ${bldgNum}=                 Get value from json        ${JsonObj}       $.result.bldgNum
    ${buildingName}=            Get value from json        ${JsonObj}       $.result.buildingName
    ${address}=                 Get value from json        ${JsonObj}       $.result.address
    ${city}=                    Get value from json        ${JsonObj}       $.result.city
    ${state}=                   Get value from json        ${JsonObj}       $.result.state
    ${country}=                 Get value from json        ${JsonObj}       $.result.country
    ${Buildingtype}=            Get value from json        ${JsonObj}       $.result.typeName
    ${Total Floors}=            Get value from json        ${JsonObj}       $.result.totalFloors
    #${OwnerCost}=               Get value from json        ${JsonObj}       $.result.ownerCostPerSqft
    ${BaseRentable}=            Get value from json        ${JsonObj}       $.result.baseRentable
    #${BaseYear}=                Get value from json        ${JsonObj}       $.result.baseYear
    ${TotalUsable}=             Get value from json        ${JsonObj}       $.result.totalUsable
    ${SuiteUsable}=             Get value from json        ${JsonObj}       $.result.suiteUsable
    ${TotalLeasedSuites}=       Get value from json        ${JsonObj}       $.result.totalOccupiedSuites
    ${TotalLeasedRentable}=     Get value from json        ${JsonObj}       $.result.totalLeasedArea
    ${TotalVacantSuites}=       Get value from json        ${JsonObj}       $.result.totalVacantSuites
    ${TotalVacantRentable}=     Get value from json        ${JsonObj}       $.result.totalVacantRentable
    ${latestReportVersion}=     Get value from json        ${JsonObj}       $.result.latestReportVersion
    ${reportStatusName}=        Get value from json        ${JsonObj}       $.result.reportStatusName
    ${MeasurementStandard}=     Get value from json        ${JsonObj}       $.result.measurementStandardName
    ${latestReportDate}=        Get value from json        ${JsonObj}       $.result.latestReportDate
    ${FactorMethod}=            Get value from json        ${JsonObj}       $.result.calculationMethod
    ${Factor}=                  Get value from json        ${JsonObj}       $.result.methodBLoadFactor
    ${TotalRentable}=           Get value from json        ${JsonObj}       $.result.rsfToCurrentMarketRsfVariance
    ${ClientRentable}=          Get value from json        ${JsonObj}       $.result.currentRentable
    ${RentableVariance}=        Get value from json        ${JsonObj}       $.result.rentableVariance
    ${Owner_companyName}=       Get From List                       ${Owner_companyName}      0
    ${country}=                 Get From List                       ${country}      0
    ${bldgNum}=                 Get From List                       ${bldgNum}      0
    ${buildingName}=               Get From List                    ${buildingName}            			0
    ${address}=               Get From List                         ${address}                      0
    ${city}=               Get From List                            ${city}     0
    ${state}=               Get From List                           ${state}    0
    #${country}=               Get From List                         ${country}                  0
    ${Buildingtype}=               Get From List                    ${Buildingtype}             0
    ${Total Floors}=               Get From List                    ${Total Floors}             0
    #${OwnerCost}=               Get From List                       ${OwnerCost}                0
    ${BaseRentable}=               Get From List                    ${BaseRentable}             0
    #${BaseYear}=               Get From List                        ${BaseYear}                 0
    ${TotalUsable}=               Get From List                     ${TotalUsable}              0
    ${SuiteUsable}=               Get From List                     ${SuiteUsable}              0
    #${TotalLeasedSuites}=               Get From List               ${TotalLeasedSuites}        0
    #${TotalLeasedRentable}=               Get From List             ${TotalLeasedRentable}      0
    #${TotalVacantSuites}=               Get From List               ${TotalVacantSuites}        0
    #${TotalVacantRentable}=               Get From List             ${TotalVacantRentable}      0
    ${latestReportVersion}=               Get From List             ${latestReportVersion}      0
    ${reportStatusName}=               Get From List                ${reportStatusName}         0
    ${MeasurementStandard}=               Get From List             ${MeasurementStandard}      0
    ${latestReportDate}=               Get From List                ${latestReportDate}         0
    ${FactorMethod}=               Get From List                    ${FactorMethod}             0
    ${Factor}=                  Get From List           ${Factor}                   0
    #${TotalRentable}=               Get From List                   ${TotalRentable}            0
    ${ClientRentable}=               Get From List                  ${ClientRentable}           0
    ${RentableVariance}=               Get From List                ${RentableVariance}         0

    ${Expected_Owner_companyName}=		Get Cell Value   ${dataFile}          PropertyDetails			4	2
    ${Expected_country}=		Get Cell Value   ${dataFile}          PropertyDetails			5	2
    ${Expected_bldgNum}=		Get Cell Value   ${dataFile}          PropertyDetails			6	2
    ${Expected_buildingName }=		Get Cell Value   ${dataFile}          PropertyDetails			7	2
    ${Expected_address}=		Get Cell Value   ${dataFile}          PropertyDetails			8	2
    ${Expected_city}=		Get Cell Value   ${dataFile}          PropertyDetails			9	2
    ${Expected_state}=		Get Cell Value   ${dataFile}          PropertyDetails			10	2
    ${Expected_Buildingtype}=		Get Cell Value   ${dataFile}          PropertyDetails			11	2
    ${Expected_Total Floors}=		Get Cell Value   ${dataFile}          PropertyDetails			12	2
    #${Expected_OwnerCost}=		Get Cell Value   ${dataFile}          PropertyDetails			13	2
    ${Expected_BaseRentable}=		Get Cell Value   ${dataFile}          PropertyDetails			14	2
    #${Expected_BaseYear}=		Get Cell Value   ${dataFile}          PropertyDetails			15	2
    ${Expected_TotalUsable}=		Get Cell Value   ${dataFile}          PropertyDetails			16	2
    ${Expected_SuiteUsable}=		Get Cell Value   ${dataFile}          PropertyDetails			17	2
    #${Expected_TotalLeasedSuites}=		Get Cell Value   ${dataFile}          PropertyDetails			18	2
    #${Expected_TotalLeasedRentable}=		Get Cell Value   ${dataFile}          PropertyDetails			19	2
    #${Expected_TotalVacantSuites}=		Get Cell Value   ${dataFile}          PropertyDetails			20	2
    #${Expected_TotalVacantRentable}=		Get Cell Value   ${dataFile}          PropertyDetails			21	2
    ${Expected_latestReportVersion}=		Get Cell Value   ${dataFile}          PropertyDetails			22	2
    ${Expected_reportStatusName}=		Get Cell Value   ${dataFile}          PropertyDetails			23	2
    ${Expected_MeasurementStandard}=		Get Cell Value   ${dataFile}          PropertyDetails			24	2
    ${Expected_latestReportDate}=		Get Cell Value   ${dataFile}          PropertyDetails			25	2
    ${Expected_FactorMethod}=		Get Cell Value   ${dataFile}          PropertyDetails			26	2
    ${Expected_Factor}=		Get Cell Value   ${dataFile}          PropertyDetails			27	2
    ${Expected_TotalRentable}=		Get Cell Value   ${dataFile}          PropertyDetails			28	2
    ${Expected_ClientRentable}=		Get Cell Value   ${dataFile}          PropertyDetails			29	    2
    ${Expected_RentableVariance}=		Get Cell Value   ${dataFile}          PropertyDetails			30  	2


    should be equal		${Expected_Owner_companyName}			${Owner_companyName}
    should be equal		${Expected_country}			${country}
    should be equal		${Expected_bldgNum}			${bldgNum}
    should be equal		${Expected_buildingName }			${buildingName }
    should be equal		${Expected_address}			${address}
    should be equal		${Expected_city}			${city}
    should be equal		${Expected_state}			${state}
    should be equal		${Expected_Buildingtype}			${Buildingtype}
    should be equal		${Expected_Total Floors}			${Total Floors}
    #should be equal		${Expected_OwnerCost}			${OwnerCost}
    ${Expected_BaseRentable}=       convert to string           ${Expected_BaseRentable}
    ${BaseRentable}=            convert to string       ${BaseRentable}
    should be equal		${Expected_BaseRentable}			${BaseRentable}
    #should be equal		${Expected_BaseYear}			${BaseYear}
    ${Expected_TotalUsable}=        convert to string       ${Expected_TotalUsable}
    should be equal		${TotalUsable}          318,348.65
    should be equal		${SuiteUsable}          318,223.95
    #should be equal		${Expected_TotalLeasedSuites}			${TotalLeasedSuites}
    #should be equal		${TotalLeasedRentable}              302,306.00
    #should be equal		${Expected_TotalVacantSuites}			${TotalVacantSuites}
    #should be equal		${TotalVacantRentable}          51,678.06
    should be equal		${Expected_latestReportVersion}			${latestReportVersion}
    should be equal		${Expected_reportStatusName}			${reportStatusName}
    should be equal		${Expected_MeasurementStandard}			${MeasurementStandard}
    should be equal		${Expected_latestReportDate}			${latestReportDate}
    #should be equal		${Expected_FactorMethod}			    ${FactorMethod}
    should be equal		${Expected_Factor}			            ${Factor}
    #should be equal		${TotalRentable}                        379,217.68
    should be equal		${ClientRentable}                       354,065.35
    should be equal		${RentableVariance}                     25,152.33

    ELSE IF      '${FOR}'=='company-managers-list'
    ${Name_0}=       Get value from json        ${JsonObj}       $.[0].name
    ELSE
    ${Expected_message}=        Set Variable       ['Success. ']
    Should Be Equal As Strings    ${message}    ${Expected_message}
    END


I Create Post Request For Edit And Save Property Summary
    ${End_Points}=         Get Cell Value   ${dataFile}   ${Pages}       24        3
    ${BuildingOwners}=      Set variable        1
    ${BuildingOwners}=      Create List         ${BuildingOwners}
    ${body}=         create dictionary          BuildingsId=7632    CurrentBuildingReportId=1904    OwnerId=1486    MarketRentable=0.00    Address=600 Casterly Rock     City=Anchorage    State=AK    Country=United States    Zip=48484    Name=600 Casterly Rock    BldgNum=600CAS     BuildingTypeId=1    PropertyManagerId=3125     BaseRentable=174137    InvestmentFund=-      BuildingOwners=${BuildingOwners}    Active=true     UserId=0    SelectedReportId=1904     SSIReportReviewId=1904    IsReportActive=true     ReportDate=2020-11-19	ClientRentable=354065.35     TotalRentable=379217.68	SubscriptionId=1
    ${Cookie}=             Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=             Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=             create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=           post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    ${id}=      convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Property Details Updated!']


I Create Post Request To Validate Floor And Tenant Details Features And Verify Response
    ${End_Points}=     Get Cell Value   ${dataFile}   ${Pages}       13        7
    ${body}=           create dictionary        Take=4     BuildingsId= 7632     MeasurementStandard= REBNY    CurrentReportId= 1904
    ${Cookie}=         Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=         Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Get floor and tenant detail success.']
    FOR    ${index}    IN RANGE    3
    Log    ${index}
    ${indicator_col}=       set variable        2
    ${col}=               Evaluate    int(${index})+int(${indicator_col})
    ${floorID}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.floorID
    ${floorNumber}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.floorNumber
    ${totalUsable}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.totalUsable
    ${loadFactor}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactor
    ${clientRSF}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.clientRSF
    ${stevensonRSF}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.stevensonRSF
    ${loadFactorA}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactorA
    ${loadFactorARSF}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactorARSF
    ${loadFactorB}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactorB
    ${loadFactorBRSF}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactorBRSF
    ${loadFactorBOppor}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.loadFactorBOppor
    ${marketFactorRSF}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.marketFactorRSF
    ${marketFactorOppor}=          	Get value from json        ${JsonObj}		$.result[${index}].floors.marketFactorOppor
    ${tenantID1 }=          	Get value from json        ${JsonObj}		$.result[${index}].floors.tenants[0].tenantID
    ${tenantName}=              Get value from json        ${JsonObj}		$.result[${index}].floors.tenants[0].tenantName

    ${floorID}=			Get From List		${floorID}			0
    ${floorNumber}=			Get From List		${floorNumber}			0
    ${totalUsable}=			Get From List		${totalUsable}			0
    ${loadFactor}=			Get From List		${loadFactor}			0
    ${clientRSF}=			Get From List		${clientRSF}			0
    ${stevensonRSF}=			Get From List		${stevensonRSF}			0
    ${loadFactorA}=			Get From List		${loadFactorA}			0
    ${loadFactorARSF}=			Get From List		${loadFactorARSF}			0
    ${loadFactorB}=			Get From List		${loadFactorB}			0
    ${loadFactorBRSF}=			Get From List		${loadFactorBRSF}			0
    ${loadFactorBOppor}=			Get From List		${loadFactorBOppor}			0
    ${marketFactorRSF}=			Get From List		${marketFactorRSF}			0
    ${marketFactorOppor}=			Get From List		${marketFactorOppor}			0
    ${tenantID1}=			Get From List		${tenantID1}			0
    ${tenantName}=			Get From List		${tenantName}			0

    ${Expected_floorID}=		Get Cell Value    ${dataFile}    TenantListing		2	${col}
    ${Expected_floorNumber}=	Get Cell Value    ${dataFile}    TenantListing		3	${col}
    ${Expected_floorNumber}=			convert to string       ${Expected_floorNumber}

    ${Expected_totalUsable}=	Get Cell Value    ${dataFile}    TenantListing		4	${col}
    ${Expected_loadFactor}=		Get Cell Value    ${dataFile}    TenantListing		5	${col}
    ${Expected_clientRSF}=		Get Cell Value    ${dataFile}    TenantListing		6	${col}
    ${Expected_stevensonRSF}=	Get Cell Value    ${dataFile}    TenantListing		7	${col}
    ${Expected_loadFactorA}=	Get Cell Value    ${dataFile}    TenantListing		8	${col}
    ${Expected_loadFactorARSF}=	Get Cell Value    ${dataFile}    TenantListing		9	${col}
    ${Expected_loadFactorB}=	Get Cell Value    ${dataFile}    TenantListing		10	${col}
    ${Expected_loadFactorBRSF}=	Get Cell Value    ${dataFile}    TenantListing		11	${col}
    ${Expected_loadFactorBOppor}=	Get Cell Value    ${dataFile}    TenantListing		12	${col}
    ${Expected_marketFactorRSF}=	Get Cell Value    ${dataFile}    TenantListing		13	${col}
    ${Expected_marketFactorOppor}=	Get Cell Value    ${dataFile}    TenantListing		14	${col}
    ${Expected_tenantID1}=		Get Cell Value    ${dataFile}    TenantListing		15	 ${col}
    ${Expected_tenantName}=		Get Cell Value    ${dataFile}    TenantListing		16	 ${col}

    should be equal		${floorID}		${Expected_floorID}
    should be equal		${floorNumber}	    	${Expected_floorNumber}
    should be equal		${totalUsable}	    	${Expected_totalUsable}
    should be equal		${loadFactor}		${Expected_loadFactor}
    should be equal		${clientRSF}		${Expected_clientRSF}
    should be equal		${stevensonRSF}	    	${Expected_stevensonRSF}
    should be equal		${loadFactorA}	    	${Expected_loadFactorA}
    should be equal		${loadFactorARSF}	    	${Expected_loadFactorARSF}
    should be equal		${loadFactorB}	    	${Expected_loadFactorB}
    should be equal		${loadFactorBRSF}	    	${Expected_loadFactorBRSF}
    should be equal		${loadFactorBOppor}	    	${Expected_loadFactorBOppor}
    should be equal		${marketFactorRSF}	    	${Expected_marketFactorRSF}
    should be equal		${marketFactorOppor}	    	${Expected_marketFactorOppor}
    should be equal		${tenantID1}		${Expected_tenantID1}
    should be equal		${tenantName}		${Expected_tenantName}

    END


hello world
    log  priti

I Create Post Request For Invite User And Verify Response
    [Arguments]         ${AccountRole}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    23    3
    ${ExpectedStatus_code}=     Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    3    7
    ${role}=        Set variable    ${AccountRole}
    #${NewUseEmail}=     Generate Random String
    IF   '${role}'=='Company Manager'
    ${Email}=           set variable            ok1234@jairosoft.com
    ${IDForUser}=       Set Variable      11
    ELSE IF     '${role}'=='SSI'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    7    3
    ELSE IF     '${role}'=='User'
    ${IDForUser}=       Set Variable      3
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    9    3
    ELSE IF     '${role}'=='Company Admin'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    10    3
    ELSE IF      '${role}'=='Limited User'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    8    3
    ${IDForUser}=       Set Variable      2
    ELSE IF      '${role}'=='SSIEmployee'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    3

    END
    ${Email_encoded}=    encode_my_Data     ${Email}
    ${End_Points}=      Set Variable        ${End_Points}${Email_encoded}
    #${NewUseEmail}=     Set Variable        ${Email}
    #IF      '${UseType}'=='Valid'
    #${NewUseEmail}=     set variable    ${NewUseEmail}@email.com
    #ELSE IF         '${UseType}'=='Existing'
    #${NewUseEmail}=     set variable        ${Email}
    #ELSE
    #${NewUseEmail}=     set variable    ${NewUseEmail}@email
    #END
    #${body}=        set variable        [{"Email":"${NewUseEmail}"}]
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,
    #Verifying email availibity  :: validate-email-address
    ${body}=            create dictionary      CompanyID=1486         BuildingsId=${BUILDID}        Email=${Email}
    ${body}=            Create List            ${body}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    log         ${Email}
    log         ${Email_encoded}
    ${AuthPhoneNumber}      Get Cell Value    ${dataFile}    ${datasheetLogin}    2    5
    ${AuthPhoneNumber}=     Convert To String    ${AuthPhoneNumber}
    ${AuthPhoneNumber}=     encode_my_Data    ${AuthPhoneNumber}
    ${body}=        create dictionary      AuthPhoneNumber=${AuthPhoneNumber}         Phone=KDc=       Email=${Email_encoded}
    #/api/account/update-login-profile
    ${End_Points}       Get Cell Value    ${dataFile}    ${Pages}     15        2

I Create Post Request For Invite User With AddPropertyList And Verify Response
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    9    3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=         create dictionary      UserId=0        CompanyID=1486       BuildingsId=7578          Email=random@email.com
    ${body}=            create list         ${body}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}     data=${body}     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Successsfully Update Data: Mail sent.']


I Create Post Request For Update Report Changes
    ${End_Points}=              Set Variable        /api/request/update-report-changes
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=         create dictionary      NewFileUrl= https://qa.truspace.com/api/pdf-viewer/GetPdfFromCloud?docName=annotedfile.pdf&clientId=l6wv1fmw6otn9o07d9d       BuildingReportId=4687
    ${form_data}=    Evaluate    {'mldata=': str(${body}).replace("'",'"')}
    ${response}=       post request    API_Testing         ${End_Points}     files=${form_data}     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    #Should Be Equal As Strings    ${message}    ['Successsfully Update Data']



I Create Post Request For Invite User And Verify Response For Company Admin
    #ValidateDomainName
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    28    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #validate-email-address
    ${Emailid}=                    Generate Random String      6
    ${Emailid}=                 Set Variable       ${Emailid}@gmail.com
    ${Emailid}=                 encode_my_Data      ${Emailid}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    29    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Email Available']
    #CompanyNameCheck
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    30    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #LoadAllUsers
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    31    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${body}=           create dictionary         Take=${Take_pageCount}       Skip=${skip}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully Retrieved User Listing']
    #PropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    32    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Successfully Retrieved Property List']
    #AuditTrail1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    33    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary      UserId=${UserId}        Username=pritibhushanf@gmail.com     Email=pritibhushanf@gmail.com      EventPage=External Member List      EventPageUrl=/external-member-list    EventName=Property List click   EventDescription=Property List undefined       CompanyId=1486	EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully to Save to Database']
    #AddPropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    34    2
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${body}=            create dictionary      CompanyID=3665        BuildingsId=7578  IsInviteExternal=${true}    IsSelected=${true}     Email=pritimindfulness@gmail.com
    ${body}=            create list         ${body}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${End_Points}=          Set variable        ${End_Points}/${UserId}/invite/3
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successsfully Update Data: Mail sent.']

I Create Post Request For Invalid email for invite user in company admin
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    34    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${body}=            create dictionary      CompanyID=3665        BuildingsId=7578  IsInviteExternal=${true}    IsSelected=${true}     Email=pritimindfulnessgmail.com
    ${body}=            create list         ${body}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${End_Points}=          Set variable        ${End_Points}/${UserId}/invite/3
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successsfully Update Data: False']

I Create Post Request For Company admin can invite already existing member
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    34    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${body}=            create dictionary      CompanyID=3665        BuildingsId=7578  IsInviteExternal=${true}    IsSelected=${true}     Email=pritibhushanf@gmail.com
    ${body}=            create list         ${body}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${End_Points}=          Set variable        ${End_Points}/${UserId}/invite/3
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    #Should Be Equal As Strings    ${message}        ['Successsfully Update Data: False']

I Create Post Request For Create Order For Comapany Admin
    #Audit trail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=${UserId}	  Email=pritibhushanf@gmail.com    UserName=pritibhushanf@gmail.com   EventPage=Create Order  EventPageUrl=/create-an-order	  CompanyId=1486	EventName=Redirect Page	  EventDescription=redirect to /create-an-order	    EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    #decrypt-user-detail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    38    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${false}=        Convert To Boolean    false
    ${body}=            create dictionary        firstName=omZ3BtnItPx3k/456ZfUNw==  lastName=omZ3BtnItPx3k/456ZfUNw==  email=uCf9y55a1Usg/jE0/YfrIUF0L21kJd9aAAxdr5WlrhGSTIwLfngJfUS8fZeM0HtR  phone=t/VWcnddruZF9zNfLczTzg==  companyName=omZ3BtnItPx3k/456ZfUNw==  assocCompanyName=1eCnzYzUjQG1sHZcXuczO/HcVfVJ0thnuX89cJdeUCU=  changePassword=${false}  active=${true}    companyId= 1486    roleId= 4
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For Update Property Summary
   ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    40    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Buildeingowners}=         Create List     0
    ${body}=            create dictionary        BuildingsId=7632    CurrentBuildingReportId=1904    OwnerId=1486    Address=600 Casterly Rock    City=Anchorage    State=AK    Country=United States    Zip=48484     Name=600 Casterly Rock    BldgNum=600CAS    BuildingTypeId=1   PropertyManagerId=3125    BaseRentable=174137    BuildingOwners=${Buildeingowners}    Active=true    UserId=0    SelectedReportId=1904    SSIReportReviewId=1904    IsReportActive=true    ReportDate=2020-11-19    ClientRentable=354065.35    TotalRentable=379217.68    SubscriptionId=1
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For View Property Details and verify Measurement Reports
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Buildeingowners}=         Create List     0
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=${UserId}	  Email=pritibhushanf@gmail.com    UserName=pritibhushanf@gmail.com   EventPage=Measurement Reports  EventPageUrl=/measurement-reports/7578	  CompanyId=1486	EventName=Redirect Page	  EventDescription=redirect to /measurement-reports/7578	    EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For AuditTrail To Navigate To Current Floor and Tenant Listing
    #Auditrail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=${UserId}	  Email=pritibhushanf@gmail.com    UserName=pritibhushanf@gmail.com   EventPage=Tenant Listing  EventPageUrl=/tenant-listing/7578	  CompanyId=1486	EventName=Download/Print button click	  EventDescription=Download/Print modal popup	    EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For floor-and-tenant-detail
    #floor-and-tenant-detail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    41    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${true}=        Convert To Boolean    true
    ${false}=        Convert To Boolean    false
    ${body}=            create dictionary         BuildingsId=7578  FloorOrder=${true}  Take=10  IsSearch=${false}  CurrentReportId=2406
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200


I Create Post Request For GenerateExcelReport
    #GenerateExcelReport
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    42    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${true}=        Convert To Boolean    true
    ${false}=        Convert To Boolean    false
    ${contents}=    Get File      C:\\JairoJobs\\TenantEncoded.txt
    @{lines}=       Split to lines   ${contents}
    FOR     ${P}     IN     @{lines}
    ${TenantEncode}=        Set variable        ${P}
    END
    ${body}=            create dictionary       TenantBuildingId=7578  TenantReportVersionId=2406     TenantEncoded=${TenantEncode}  Name=a a	Email=pritibhushanf@gmail.com  ReportType=Preliminary  FileName=1234 South Main Street  MeasurementStandardName=ANSI/BOMA Z65.5-2020 RETAIL STANDARD  DisplayMarketOverride=${false}  SubscriptionId=2
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For share Measurement Report
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    43    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${true}=        Convert To Boolean    true
    ${false}=        Convert To Boolean    false
    ${EmailBodyDisabled}=    Get File      EmailBodyDisabled.txt
    @{lines}=       Split to lines   ${EmailBodyDisabled}
    FOR     ${P}     IN     @{lines}
    ${EmailBodyDisabled}=        Set variable        ${P}
    END
    ${emailtesst}=      Set variable        testx@gmail.com
    ${emailtesst}=      Create List         ${emailtesst}
    ${body}=            create dictionary       Subject=600 Casterly Rock Building Measurement Report	Emails=${emailtesst}	BuildingNumber=600CAS	  UserEmail=pritibhushanf@gmail.com  UserId=${UserId}	OrderId=1904    EmailBodyDisabled=${EmailBodyDisabled}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For view Report Updates
    #ReportUpdatesFeature
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    17    7
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    #Audittrail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=${UserId}	  Email=pritibhushanf@gmail.com    UserName=pritibhushanf@gmail.com   EventPage=Report Updates  EventPageUrl=/report-updates/7632	  CompanyId=1486	EventName=Redirect Page	  EventDescription=Redirect to /report-updates/7632	    EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For redirect to Order details when clicking related order
    #Auditrail
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    8    3
    ${body}=            create dictionary       UserId=${UserId}	  Email=pritibhushanf@gmail.com    UserName=pritibhushanf@gmail.com   EventPage=Order Details  EventPageUrl=/order-details/17756	  CompanyId=1486	EventName=Redirect Page	  EventDescription=Redirect to /order-details/17756	    EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For Invite User And Verify Response For Company Manager
    #ValidateDomainName
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    28    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #validate-email-address
    ${Emailid}=                    Generate Random String      6
    ${Emailid}=                 Set Variable       ${Emailid}@jairosoft.com
    ${Emailid}=                 encode_my_Data      ${Emailid}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    29    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Email Available']
    #CompanyNameCheck
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    30    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #LoadAllUsers
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    31    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${body}=           create dictionary         Take=${Take_pageCount}       Skip=${skip}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully Retrieved User Listing']
    #PropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    32    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Successfully Retrieved Property List']
    #AuditTrail1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    33    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    ${Emailid}=        Get Cell Value    ${dataFile}    ${datasheetLogin}          11   3
    ${body}=           create dictionary      UserId=${UserId}        Username=${Emailid}     Email=${Emailid}      EventPage=External Member List      EventPageUrl=/external-member-list    EventName=Property List click   EventDescription=Property List undefined       CompanyId=1486	EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully to Save to Database']
    #AddPropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    34    2
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${body}=            create dictionary      CompanyID=3665        BuildingsId=7578  IsInviteExternal=${true}    IsSelected=${true}     Email=${Emailid}
    ${body}=            create list         ${body}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${End_Points}=          Set variable        ${End_Points}/${UserId}/invite/3
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successsfully Update Data: Mail sent.']

I Create Post Request For Invite User And Verify Response For SSIEmployee
    #ValidateDomainName
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    28    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #validate-email-address
    ${Emailid}=                    Generate Random String      6
    ${Emailid}=                 Set Variable       ${Emailid}@jairosoft.com
    ${Emailid}=                 encode_my_Data      ${Emailid}
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    29    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Email Available']
    #CompanyNameCheck
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    30    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Success. ']
    #LoadAllUsers
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    31    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${body}=           create dictionary         Take=${Take_pageCount}       Skip=${skip}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully Retrieved User Listing']
    #PropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    32    2
    ${End_Points}=              Set Variable        ${End_Points}${Emailid}
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session    API_Testing         ${End_Points}     headers=${header}
    ${JsonObj}=         to json     ${response.content}
    ${id}=              Get value from json        ${JsonObj}       $.statusCode
    ${id}=              convert to string                   ${response.status_code}
    should be equal     ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}    ['Successfully Retrieved Property List']
    #AuditTrail1
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    33    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${Take_pageCount}=      Set variable            30
    ${skip}=            Set Variable        0
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    ${Emailid}=        Get Cell Value    ${dataFile}    ${datasheetLogin}          12   3
    ${body}=           create dictionary      UserId=0        Username=crmtest@StevensonSystems.onmicrosoft.com     Email=crmtest@StevensonSystems.onmicrosoft.com      EventPage=Member List      EventPageUrl=/member-list    EventName=Property List click   EventDescription=Property List undefined       CompanyId=1486	EventStatus=Successful
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successfully to Save to Database']
    #AddPropertyList
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    34    2
    ${UserId}=         Get Cell Value    ${dataFile}    ${DataSheetEditDashBoard}    9    3
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${true}=        Convert To Boolean    true
    ${body}=            create dictionary      CompanyID=3665        BuildingsId=7578  IsInviteExternal=${true}    IsSelected=${true}     Email=${Emailid}
    ${body}=            create list         ${body}
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${End_Points}=          Set variable        ${End_Points}/${UserId}/invite/3
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.message
    Should Be Equal As Strings    ${message}        ['Successsfully Update Data: Mail sent.']

I Create Post Request For Save Create Order
    [Arguments]         ${AccountRole}
    IF   '${AccountRole}'=='Company Manager'
    ${Email}=           set variable            ok1234@jairosoft.com
    ${IDForUser}=       Set Variable      11
    ELSE IF     '${AccountRole}'=='SSI'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    7    3
    ${End_Points}=              Set Variable        /api/request/SaveRequest

    ELSE IF     '${AccountRole}'=='User'
    ${IDForUser}=       Set Variable      3
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    9    3
    ELSE IF     '${AccountRole}'=='Company Admin'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    10    3
    ELSE IF      '${AccountRole}'=='Limited User'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    8    3
    ${IDForUser}=       Set Variable      2
    ELSE IF      '${AccountRole}'=='SSIEmployee'
    ${Email}=           Get Cell Value    ${dataFile}    ${datasheetLogin}    12    3
    ${End_Points}=              Set Variable        /api/request/SaveRequest/true

    END


    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded      Cookie=${Cookie}
    ${body}=         create dictionary      ServiceTypeId=6		UserId=2854	Email=${Email}	FirstName=Cindy		LastName=Manager	Company=MY ACCESS, INC.	CompanyId=1486		Phone=(111) 111-1111	PropertyAddress=Cebu	FloorNumber=3	SuiteNumber=2	PropertyAddress=Camb	PropertyCity=2	PropertyState=PA	PropertyZip=16823
    ${response}=       post request    API_Testing         ${End_Points}     data=${body}     headers=${headers}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200
    ${message}=      Get value from json        ${JsonObj}       $.result.requestId
    ${message}=			Get From List		${message}			0
    write data      ${dataFile}     ${Pages}    36    3   ${message}


I Create Post Request For Cancel Order
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    45    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${RequestId}=               Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=           create dictionary         RequestId= ${RequestId}	UserId= 2854    FirstName= Cindy    LastName= Manager	Email= cindyacr19@gmail.com    Phone= (111) 111-1111    CompanyId= 1486    Company= MY ACCESS INC.        PropertyAddress= 225 Rogers Street Northeast    PropertyCity= Atlanta    PropertyState= GA    PropertyZip= 30317    FloorNumber= 3    SuiteNumber= 3    CalcChange= false    InteriorChange= false     SsiFile= false    SsiReportId= 3    Comments= test postman    RequestTypeId= 4    RequestType= Additional Requests    ServiceTypeId= 6    ServiceType= Suite CalculationRequestDate= 2021-09-02T18:38:31.217    CompletionDate= 2021-09-02T19:44:47.46    LastUpdateDate= 2021-09-02T20:06:44.993     Billable= false    AssignedUser= John Cruz    AssignedUserId= 1459    AssignedDate= 2021-09-02T19:44:43.13    StartDate= 2021-09-02T19:44:47.46    IsSeen= false    IsRead= true     OrderStatus= Completed    requestStatusId= 4    SendEmailToClient= true
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200


I Create Get Request For assign Order to a resource
    ${End_Points}=         Get Cell Value    ${dataFile}    ${Pages}    46    2
    ${RequestId}=               Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}${RequestId}/1459/false     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Get Request Start An order And Set Status To Pending
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${End_Points}=         Get Cell Value    ${dataFile}    ${Pages}    47    2
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}${orderId}     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Get Request Start An Order And Set Status To Paused
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${End_Points}=         Get Cell Value    ${dataFile}    ${Pages}    48    2
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}${orderId}     headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create POST Request To Edit Order Details
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    45    2
    ${Cookie}=                  Get Cell Value    ${dataFile}    ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    create session              API_Testing       ${API_Base_Endpoint}
    ${UpdatedName}=                    Generate Random String      6
    ${UpdatedName}=                 Set Variable       ${UpdatedName}@jairosoft.com
    ${body}=           create dictionary           RequestId= ${orderId}	UserId=0	FirstName=${UpdatedName} 	RequestTypeId=0		requestStatusId=1
    ${header}=         create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=       post request    API_Testing         ${End_Points}/0          headers=${header}         data=${body}
    #${JsonObj}=        to json     ${response}
    #${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create POST Request To Attached Client Uploads
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    49    2
    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    #${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    #${body}=         create dictionary      RequestId=18497		UserId=0	Email=carrogancia@contractors.stevensonsystems.com	file[0]=(binary)
    #${form_data}=    Evaluate    {'mldata=': str(${body}).replace("'",'"')}
    #${response}=       post request    API_Testing         ${End_Points}     files=${form_data}     headers=${header}
    #${JsonObj}=        to json     ${response.content}
    #${id}=             Get value from json        ${JsonObj}       $.statusCode
    #${id}=             convert to string                   ${response.status_code}
    #should be equal         ${id}         200
    #${message}=      Get value from json        ${JsonObj}       $.message
    #**************************
    ${data}=    Create Dictionary    RequestId=${orderId}		UserId=0	Email=carrogancia@contractors.stevensonsystems.com	file[0]=(binary)
    ${headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded      Cookie=${Cookie}
    ${response}=    Post Request    API_Testing         ${End_Points}    data=${data}    headers=${headers}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${id}
    should be equal         ${id}         [200]

I Create POST Request To Remove Order
#    #LoadRequestList
#    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    50    2
#    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
#    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
#    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
#    create session              API_Testing       ${API_Base_Endpoint}
#    ${body}=           create dictionary         UserId=0	IsReportsFeatureActive=true	 Take=10  	ShowActive=true
#    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
#    ${JsonObj}=        to json     ${response.content}
#    ${id}=             Get value from json        ${JsonObj}       $.statusCode
#    ${id}=             convert to string                   ${response.status_code}
#    should be equal         ${id}         200
#    ${message}=      Get value from json        ${JsonObj}       $.result.requests[0].requestId
#    ${message}=			Get From List		${message}			0
#    write data      ${dataFile}     ${Pages}    50    3   ${message}
    #removeorder
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=           create dictionary         UserId=0	Email=carrogancia@contractors.stevensonsystems.com	UserName=carrogancia@contractors.stevensonsystems.com	EventPage=Order Details   EventPageUrl=/order-details/${orderId}	CompanyId=2	EventName=Removed order  #${orderId}  #EventDescription=Order remove	 EventStatus=Successful
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${response.status_code}
    should be equal         ${id}         200

I Create Post Request For merge Order
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    37    2
    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    create session              API_Testing       ${API_Base_Endpoint}
    ${body}=           create dictionary         UserId=0	Email=carrogancia@contractors.stevensonsystems.com	UserName=carrogancia@contractors.stevensonsystems.com	EventPage=Order Details   EventPageUrl=/order-details/${orderId}	CompanyId=2	EventName=Merged order #18499 with order #18589  	EventDescription=Order merge	 EventStatus=Successful
    ${response}=       post request    API_Testing         ${End_Points}          headers=${header}         data=${body}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${id}
    should be equal         ${id}         [200]

I Create POST Request To Remove Attached Client Uploads
    #GetRequestDetails
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    53    2
    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${orderId}=             Get Cell Value    ${dataFile}    ${Pages}    36    3
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${End_Points}=              set variable        ${End_Points}/${orderId}
    ${response}=                GET On Session    API_Testing         ${End_Points}          headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${id}
    should be equal         ${id}         [200]
    ${ssifilesID}=             Get value from json        ${JsonObj}       $.result[0].requestLogId
    ${ssifilesID}=			Get From List		${ssifilesID}			0
    #DeleteRequestFile
    ${End_Points}=              Get Cell Value    ${dataFile}    ${Pages}    52    2
    ${Cookie}=                  Get Cell Value    ${dataFile}     ${datasheetLogin}    2    10
    ${Cookie}=                  Set Variable    .AspNetCore.Session=${Cookie}
    ${header}=                  create dictionary       Content-type=application/json,      Cookie=${Cookie}
    create session              API_Testing       ${API_Base_Endpoint}
    ${End_Points}=              set variable        ${End_Points}/${ssifilesID}
    ${response}=                GET On Session    API_Testing         ${End_Points}          headers=${header}
    ${JsonObj}=        to json     ${response.content}
    ${id}=             Get value from json        ${JsonObj}       $.statusCode
    ${id}=             convert to string                   ${id}
    should be equal         ${id}         [200]



I create put request
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     headers=${header}
