*** Settings ***
Library     RequestsLibrary
Library     os
Library     JSONLibrary
Library     Collections
Library     DataDriver  TestData/TestData.xlsx   sheet_name=Sheet6
Test Template    Mykeywork


*** Test Cases ***
TC001_Get_Request_forLogin using ${API_Base_Endpoint}

*** Keywords ***
Mykeywork
    [Arguments]     ${API_Base_Endpoint}    ${End_Points}   ${Status_code}
    create session      API_Testing       ${API_Base_Endpoint}
    ${response}=        GET On Session        API_Testing         ${End_Points}
    log to console      ${response.status_code}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         ${Status_code}
