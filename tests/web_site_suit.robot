*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser  https://www.demoblaze.com/  Chrome
Suite Teardown    Close Browser

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


