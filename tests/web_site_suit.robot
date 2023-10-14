*** Settings ***
Library           /Users/Mikhail_Chizhov/PycharmProjects/pythonProject1/my_new_env/lib/python3.9/site-packages/SeleniumLibrary
Library    String
Suite Setup       Open Browser  https://www.demoblaze.com/  Chrome
Suite Teardown    Close Browser

*** Variables ***
${MAX_PRICE}      0
${MAX_INDEX}      None

*** Test Cases ***
User Login Test
    [Documentation]  Test user login
    [Tags]  Login
    ${username}=  Set Variable  test_user0000

    # Click on the login button
    Click Element  id=login2
    Wait Until Element Is Visible  id=loginusername

    # Assert that the login and password fields are present
    Element Should Be Visible  id=loginusername
    Element Should Be Visible  id=loginpassword

    # Enter credentials and log in
    Input Text  id=loginusername  ${username}
    Input Text  id=loginpassword  Test1234
    Click Element  xpath=//*[@id='logInModal']/div/div/div[3]/button[2]
    Wait Until Element Is Visible  id=logout2

    # Assert that logout button and welcome message are displayed
    Element Should Be Visible  id=logout2
    Page Should Contain  Welcome ${username}



*** Test Cases ***
Product Selection Test
    [Documentation]  Test product selection and adding to cart
    [Tags]  Product


    ${driver}=  Login
    Click Element  link=Monitors
    Sleep  2s
    ${count}=    Get Element Count    xpath=//*[@id="tbodyid"]/div
    Log    Total number of divs inside tbodyid: ${count}

    FOR    ${i}    IN RANGE    1    ${count + 1}
        ${price_path}=    Set Variable    //*[@id="tbodyid"]/div[${i}]/div/div/h5
        ${price_text}=    Get Text    ${price_path}
        Log    Price text for div ${i}: ${price_text}
        ${price}=    Extract Number From Price    ${price_text}
        Log    Price value for div ${i}: ${price}

        Run Keyword If    ${price} > ${MAX_PRICE}    Update Max Price    ${price}    ${i}
        Log    Current max price: ${MAX_PRICE} for div at index ${MAX_INDEX}
    END

    Click Element    xpath=//*[@id="tbodyid"]/div[${MAX_INDEX}]
    Log    Clicked on div at index ${MAX_INDEX} with highest price of ${MAX_PRICE}
    Sleep  3s

    # Step 4: Click on Cart button
    Click Element  id=cartur



*** Keywords ***
Login
    [Documentation]  Log in with test credentials
    ${driver}=  Create Webdriver  Chrome
    Go To  https://www.demoblaze.com/
    Click Element  id=login2
    Wait Until Element Is Visible  id=loginusername
    Input Text  id=loginusername  test_user0000
    Input Text  id=loginpassword  Test1234
    Click Element  xpath=//*[@id='logInModal']/div/div/div[3]/button[2]
    Wait Until Element Is Visible  id=logout2
    [Return]  ${driver}


Extract Number From Price
    [Arguments]    ${price_text}
    ${price_without_dollar}=    Replace String    ${price_text}    $    ${EMPTY}
    ${number}=    Convert To Number    ${price_without_dollar}
    [Return]    ${number}

Update Max Price
    [Arguments]    ${price}    ${index}
    Set Test Variable    ${MAX_PRICE}    ${price}
    Set Test Variable    ${MAX_INDEX}    ${index}
    Log    Updated max price to ${price} for child element at index ${index}