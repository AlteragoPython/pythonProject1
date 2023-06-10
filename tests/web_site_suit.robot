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



*** Test Cases ***
Product Selection Test
    [Documentation]  Test product selection and adding to cart
    [Tags]  Product

    ${driver}=  Login
    Select Product With Highest Price
    Click Element  link=Add to cart

    # Step 4: Click on Cart button
    Click Element  id=cartur

    # Assert that the product is in the cart
    ${cart_items}=  Get WebElements  css=div.table-responsive
    ${product_in_cart}=  Run Keyword And Return Status  Should Be True  any('${highest_price_product.text}' in '${item.text}' for item in ${cart_items})
    Should Be True  ${product_in_cart}

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

Select Product With Highest Price
    # Step 1: Click on Monitors category
    Click Element  link=Monitors
    Sleep  2s

    # Step 2: Click on the product with the highest price on the page
    ${products}=  Get WebElements  css=div.card-block
    ${highest_price}=  Set Variable  0
    ${highest_price_product}=  Set Variable  None
    FOR  ${product}  IN  @{products}
        ${price}=  Get Text  ${product}.css=h5
        ${price}=  Evaluate  float($price.replace('$', ''))
        IF  ${price} > ${highest_price}
            ${highest_price}=  Set Variable  ${price}
            ${highest_price_product}=  Set Variable  ${product}
    END
    Click Element  ${highest_price_product}.css=h4
    Wait Until Element Is Visible  css=h2

    # Assert that we're on the product page
    Element Should Be Visible  css=h4
