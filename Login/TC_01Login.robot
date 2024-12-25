*** Settings ***
Library     RequestsLibrary
Library     os
Library     JSONLibrary
Library     Collections
Library     DataDriver  TestData/TestData.xlsx   sheet_name=Sheet5
Test Template    Mykeywork

*** Test Cases ***
TC001_Post_Request_forLogin using ${API_Base_Endpoint}


*** Keywords ***
Mykeywork
    [Arguments]     ${API_Base_Endpoint}    ${Name}     ${End_Points}       ${Username}    ${Password}      ${Cookie}   ${Status_code}      ${Email}
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}      Email=${Email}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}
    ${StrinfResCode}=       convert to string         ${response.status_code}
    should be equal         ${StrinfResCode}         ${Status_code}
    #log         ${response.status_code}
    #log         @{response.cookies}
    #log         ${response.headers}
    #@{JsonObj}=             to json     ${response.cookies}
    FOR     ${P}     IN     @{response.cookies}
    log     ${P}
    END
