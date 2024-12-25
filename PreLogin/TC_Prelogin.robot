*** Settings ***
Library           ../excel_1.py
Library     SeleniumLibrary
Library     RequestsLibrary
Library     os
Library     JSONLibrary
Library     Collections
Library     DataDriver  TestData/TestData.xlsx   sheet_name=Sheet4
Library           ../excel_1.py

Test Template    Mykeywork

*** Test Cases ***
TC001_Get_Request_forPreLogin using ${API_Base_Endpoint}


*** Keywords ***
Mykeywork
    [Arguments]     ${API_Base_Endpoint}    ${End_Points}   ${Status_code}   ${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    ${StrinfResCode}=       convert to string                   ${response.status_code}
    should be equal         ${StrinfResCode}         ${Status_code}
    ${workbook}    Open Workbook    TestData/TestData.xlsx
    Write Data      ${workbook}     Sheet4      1   12      ${response.content}
    save excel      ${workbook}     TestData/TestData.xlsx