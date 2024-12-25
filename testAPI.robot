*** Settings ***
Library     RequestsLibrary
Library     Dialogs
Library     os
Library     JSONLibrary
Library     Collections
Library     excel_1.py
Library    OperatingSystem
Library    String
*** Variables ***
${dataFile}         TestData/TestData.xlsx
${datasheetLogin}        Sheet5
${datasheetPrelogin}     Sheet4
${pathFile}      TestData/TestData.xlsx
${pathFile1}      C:\\xls\\result.xlsx

*** Test Cases ***
TC001_Login
    check rows

*** Keywords ***
API Testing FOR Login
    ${rowCount}=    Get Row Count       ${dataFile}     ${datasheetLogin}
    remove sheet    ${dataFile}    resultNow
    save new excel sheet    ${dataFile}   resultNow    1   1    Name
    write data      ${dataFile}     resultNow   1       2   Response_status_code
    FOR     ${r}    IN RANGE    2   ${rowCount}+1
    ${Name}=        Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    1
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    2
    ${End_Points}=    Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    3
    ${Username}=    Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    4
    ${Password}=    Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    5
    ${Status_code}=    Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    7
    ${Email}=    Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    8
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    ${r}    6
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}
    create session      API_Testing       ${API_Base_Endpoint}
    ${body}=            create dictionary      Username=${Username}   Password=${Password}      Email=${Email}
    ${header}=          create dictionary       Content-type=application/json,      Cookie=${Cookie}
    ${response}=        post request        API_Testing         ${End_Points}     data=${body}        headers=${header}

    should be equal     ${response.status_code}     ${Status_code}
    write data      ${dataFile}     resultNow    ${r}   1     ${Name}
    write data      ${dataFile}     resultNow    ${r}   2    ${response.status_code}
    write data      ${dataFile}     resultNow    ${r}   3    ${response.content}
    Run keyword if  '${Name}' == 'Login Page'   Get_Cookies_From_Login  ${r}    @{response.cookies}
    END


API Testing FOR Prelogin
    ${rowCount}=    Get Row Count       ${dataFile}     ${datasheetPrelogin}
    remove sheet    ${dataFile}    resultNowPrelogin
    save new excel sheet    ${dataFile}   resultNowPrelogin    1   1    Name
    write data      ${dataFile}     resultNowPrelogin   1       2   Response_status_code
    FOR     ${r}    IN RANGE    2   ${rowCount}+1
    ${Name}=        Get Cell Value    ${dataFile}    ${datasheetPrelogin}    ${r}    1
    ${API_Base_Endpoint}=  Get Cell Value    ${dataFile}    Sheet4    ${r}    2
    ${End_Points}=    Get Cell Value    ${dataFile}    ${datasheetPrelogin}    ${r}    3
    ${Status_code}=    Get Cell Value    ${dataFile}    ${datasheetPrelogin}    ${r}    4
    ${Cookie}=       Get Cell Value    ${dataFile}    ${datasheetLogin}    3    6
    ${Cookie}=      Set Variable    .AspNetCore.Session=${Cookie}

    create session      API_Testing       ${API_Base_Endpoint}
    ${header}=          create dictionary       Content-type=application/json,  Cookie=${Cookie}
    ${response}=        GET On Session        API_Testing         ${End_Points}     headers=${header}
    should be equal     ${response.status_code}     ${Status_code}
    write data      ${dataFile}     resultNowPrelogin    ${r}     1     ${Name}
    write data      ${dataFile}     resultNowPrelogin    ${r}   2    ${response.status_code}
    write data      ${dataFile}     resultNowPrelogin    ${r}   3    ${response.content}
    END

Login in sts for c
    open browser    https://uat-myaccess.stevensonsystems.com     chrome
    Input text    //*[@ng-model='userCredentials.email']    ZavantiAdmin@stevensonsystems.com
    Click Element    //*[@class='btn btn-login-continue']
    Wait Until Page Contains Element    //*[@class='btn btn-login']
    Input text    //*[@ng-model='userCredentials.password']    uga9uRYdZtQ
    Click Element    //*[@class='btn btn-login']
    Wait Until Page Contains Element    //*[@class='btn btn-submit-2faMobile mr-4']
    Click Element    //button[@class='btn btn-submit-2faMobile mr-4']
    #2FA_Code
    ${h}=    get value from user        2fa
    Input text    //input[contains(@class,'form-control rounded 2fa-code')]    ${h}

    click element       //button[@class='btn btn-submit-2faCode mr-4 ng-binding']

    ${ck1}=     Get Cookie      .AspNetCore.Session
    log         ${ck1}


Get_Cookies_From_Login
    [Arguments]    ${r}     @{response}
    FOR     ${P}     IN     @{response}

    write data      ${dataFile}     ${datasheetLogin}    ${r+1}    6   ${P.value}
    END


check rows
    ${String} =         Set Variable        priti bhushan
    ${String1}=         Split String        ${String}
    log         ${String1}[0]

#    ${kk}=      file exist      ${pathFile}
#    IF  '${kk}'=='True'
#    log             delete
#    delete file     ${pathFile}
#    ELSE
#
#    #${opop} =    get row count    ${dataFile}    Sheet8
#    log     click and get row
#    END
