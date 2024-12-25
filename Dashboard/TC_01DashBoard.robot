*** Settings ***
Library     RequestsLibrary
Library     os
Library     JSONLibrary
Library     Collections
Library     DataDriver  TestData/TestData.xlsx   sheet_name=Sheet7
Test Template    Mykeywork


*** Test Cases ***
TC001_Get_Request_for Dashboard using ${API_Base_Endpoint}

*** Keywords ***
Mykeywork
    [Arguments]     ${API_Base_Endpoint}    ${End_Points}   ${Status_code}      ${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         ${Status_code}
    ${JsonObj}=             to json     ${response.content}
    ${id}=                  Get value from json        ${JsonObj}       $.statusCode
    log to console          ${id}
