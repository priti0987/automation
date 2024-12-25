*** Settings ***
Library           ../excel_1.py
Library    os
*** Variables ***
${Name}
${API_Base_Endpoint}
${End_Points}
${Status_code}
${Cookie}

*** Keywords ***
Open MyWorkbook
    ${workbook}    Open Workbook    TestData/TestData.xlsx
    Log    ${workbook}

Get Cell Value
    ${workbook}    Open Workbook    TestData/TestData.xlsx
    ${cell_value}    Get Cell Value    ${workbook}    Sheet1    1    1
    Log    ${cell_value}

Write value
    ${workbook}    Open Workbook    TestData/TestData.xlsx
    Write Data      ${workbook}     Sheet1      1   12      PritiBhushan
    save excel      ${workbook}     TestData/TestData.xlsx

get data
    ${workbook}    Open Workbook    TestData/TestData1.xlsx
    @{rowCount}=    Get Row Count       ${workbook}     Sheet4
    log        @{rowCount}.value
    FOR     ${r}    IN    @{rowCount}
    ${index}        Set Variable    1
        #FOR     ${v}    IN   @{r}
        FOR    ${index}    ${v}    IN ENUMERATE    @{r}    start=1
            log     ${index}
            log     ${v.value}
            ${type string}=    Evaluate     type($index)
            ${type string}=    Evaluate     type(1)

            Log     ${type string}
            AssignVariable     ${index}        ${v.value}
        END
    END

*** Keywords ***
AssignVariable
    [Arguments]     ${arg1}     ${arg2}
    IF  ${arg1} == 1
        ${Name}     Set Variable   ${arg2}
        log     ${Name}
    ELSE IF     ${arg1} == 2
        ${API_Base_Endpoint}     Set Variable   ${arg2}
        log     ${API_Base_Endpoint}
    ELSE IF     ${arg1} == 3
        ${End_Points}     Set Variable   ${arg2}
        log     ${End_Points}
    ELSE IF     ${arg1} == 4
        ${Status_code}     Set Variable   ${arg2}
        log     ${Status_code}
    ELSE IF     ${arg1} == 5
        ${Cookie}     Set Variable   ${arg2}
        log     ${Cookie}
    END
