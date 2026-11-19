*** Settings ***
Documentation      Operational Page Object keywords for CURA Healthcare Service.
...                Encapsulates SeleniumLibrary interactions and references locators.robot.
Library            SeleniumLibrary
Resource           ../locators/locators.robot

*** Variables ***
${BASE_URL}              https://katalon-demo-cura.herokuapp.com/
${LOGIN_URL}             https://katalon-demo-cura.herokuapp.com/profile.php#login
${APPOINTMENT_URL}       https://katalon-demo-cura.herokuapp.com/#appointment
${BROWSER}               chrome
${DEFAULT_TIMEOUT}       10s
${VALID_USERNAME}        John Doe
${VALID_PASSWORD}        ThisIsNotAPassword
${INVALID_USERNAME}      InvalidUser
${INVALID_PASSWORD}      InvalidPassword123
${EXPECTED_LOGIN_ERROR}  Login failed! Please ensure the username and password are valid.

*** Keywords ***
# --- Browser Management ---
Open CURA Application
    [Documentation]    Opens browser with maximized window and explicit timeouts.
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${chrome_options}    add_argument    --window-size\=1920,1080
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    Set Selenium Timeout    ${DEFAULT_TIMEOUT}
    Wait Until Element Is Visible    ${NAV_BTN_MAKE_APPOINTMENT}

Close CURA Application
    [Documentation]    Closes the active browser session.
    Close Browser

# --- Login Page Keywords ---
Navigate To Login Page
    [Documentation]    Navigates to the Login page via URL.
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOGIN_INPUT_USERNAME}

Input Login Credentials
    [Documentation]    Inputs username and password into login fields.
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${LOGIN_INPUT_USERNAME}
    Clear Element Text    ${LOGIN_INPUT_USERNAME}
    Input Text    ${LOGIN_INPUT_USERNAME}    ${username}
    Clear Element Text    ${LOGIN_INPUT_PASSWORD}
    Input Password    ${LOGIN_INPUT_PASSWORD}    ${password}

Click Login Button
    [Documentation]    Clicks the login submission button.
    Wait Until Element Is Visible    ${LOGIN_BTN_SUBMIT}
    Click Button    ${LOGIN_BTN_SUBMIT}

Verify Login Error Message Displayed
    [Documentation]    Verifies that the invalid login alert message is displayed with expected text.
    Wait Until Element Is Visible    ${LOGIN_TXT_ERROR_MSG}
    Element Text Should Be    ${LOGIN_TXT_ERROR_MSG}    ${EXPECTED_LOGIN_ERROR}

Verify Redirected To Appointment Page
    [Documentation]    Verifies successful redirection to Make Appointment page.
    Wait Until Element Is Visible    ${APPOINTMENT_TXT_HEADER}
    Location Should Contain    \#appointment
    Element Should Be Visible    ${APPOINTMENT_BTN_BOOK}

Login To Application With Valid Credentials
    [Documentation]    Re-usable keyword to perform complete valid login flow (TC 1.2 prerequisite).
    Navigate To Login Page
    Input Login Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Click Login Button
    Verify Redirected To Appointment Page

# --- Make Appointment Page Keywords ---
Fill Appointment Form Without Date
    [Documentation]    Fills all appointment fields except the mandatory Visit Date field.
    [Arguments]    ${facility}=Tokyo CURA Healthcare Center    ${readmission}=${True}    ${program}=Medicare    ${comment}=Test booking without date
    Wait Until Element Is Visible    ${APPOINTMENT_SELECT_FACILITY}
    Select From List By Label    ${APPOINTMENT_SELECT_FACILITY}    ${facility}
    Run Keyword If    ${readmission}    Select Checkbox    ${APPOINTMENT_CHK_READMISSION}
    ...    ELSE    Unselect Checkbox    ${APPOINTMENT_CHK_READMISSION}
    Select Healthcare Program    ${program}
    Clear Element Text    ${APPOINTMENT_INPUT_VISIT_DATE}
    Input Comment    ${comment}

Fill Complete Appointment Form
    [Documentation]    Fills all appointment form fields including the mandatory Visit Date.
    [Arguments]    ${facility}    ${readmission}    ${program}    ${visit_date}    ${comment}
    Wait Until Element Is Visible    ${APPOINTMENT_SELECT_FACILITY}
    Select From List By Label    ${APPOINTMENT_SELECT_FACILITY}    ${facility}
    Run Keyword If    ${readmission}    Select Checkbox    ${APPOINTMENT_CHK_READMISSION}
    ...    ELSE    Unselect Checkbox    ${APPOINTMENT_CHK_READMISSION}
    Select Healthcare Program    ${program}
    Input Visit Date    ${visit_date}
    Input Comment    ${comment}

Input Visit Date
    [Documentation]    Inputs visit date into the datepicker field and syncs with bootstrap-datepicker.
    [Arguments]    ${visit_date}
    Wait Until Element Is Visible    ${APPOINTMENT_INPUT_VISIT_DATE}
    Execute Javascript    $('#txt_visit_date').val('${visit_date}'); $('.input-group.date').datepicker('update', '${visit_date}');

Input Comment
    [Documentation]    Inputs comment text into comment textarea with reliable fallback for headless browsers.
    [Arguments]    ${comment}
    Wait Until Element Is Visible    ${APPOINTMENT_INPUT_COMMENT}
    Scroll Element Into View         ${APPOINTMENT_INPUT_COMMENT}
    Input Text                       ${APPOINTMENT_INPUT_COMMENT}    ${comment}
    ${current_val}=                  Get Value                       ${APPOINTMENT_INPUT_COMMENT}
    IF    '${current_val}' == ''
        Execute Javascript           document.getElementById('txt_comment').value = `${comment}`;
    END

Select Healthcare Program
    [Documentation]    Selects radio button for healthcare program (Medicare, Medicaid, or None) using robust JS click to prevent Bootstrap inline-radio misclicks.
    [Arguments]    ${program}
    ${locator}=    Set Variable If
    ...    '${program}' == 'Medicare'    ${APPOINTMENT_RDO_MEDICARE}
    ...    '${program}' == 'Medicaid'    ${APPOINTMENT_RDO_MEDICAID}
    ...    ${APPOINTMENT_RDO_NONE}
    Wait Until Element Is Visible    ${locator}
    Scroll Element Into View         ${locator}
    ${elem}=    Get WebElement       ${locator}
    Execute Javascript               arguments[0].click();    ARGUMENTS    ${elem}
    Radio Button Should Be Set To    programs    ${program}

Click Book Appointment Button
    [Documentation]    Clicks the Book Appointment button to submit the appointment.
    Wait Until Element Is Visible    ${APPOINTMENT_BTN_BOOK}
    Scroll Element Into View         ${APPOINTMENT_BTN_BOOK}
    Execute Javascript               document.getElementById('btn-book-appointment').click();

Verify Mandatory Date Validation Message Displayed
    [Documentation]    Verifies HTML5 validation on Visit Date field and confirms form stays on appointment page.
    ${is_missing}=    Execute Javascript    return document.getElementById('txt_visit_date').validity.valueMissing;
    Should Be True    ${is_missing}    Mandatory field validation failed: Visit Date should be required!
    ${validation_msg}=    Execute Javascript    return document.getElementById('txt_visit_date').validationMessage;
    Should Not Be Empty    ${validation_msg}    Expected browser validation message for empty date!
    Location Should Contain    \#appointment
    Element Should Be Visible    ${APPOINTMENT_TXT_HEADER}

Verify Appointment Confirmation Details
    [Documentation]    Verifies appointment confirmation header and matches displayed data with input data.
    [Arguments]    ${facility}    ${readmission}    ${program}    ${visit_date}    ${comment}
    Wait Until Element Is Visible    ${SUMMARY_TXT_HEADER}
    Location Should Contain    appointment.php\#summary
    Element Text Should Be    ${SUMMARY_TXT_FACILITY}       ${facility}
    ${expected_readmission}=    Set Variable If    ${readmission}    Yes    No
    Element Text Should Be    ${SUMMARY_TXT_READMISSION}    ${expected_readmission}
    Element Text Should Be    ${SUMMARY_TXT_PROGRAM}        ${program}
    Element Text Should Be    ${SUMMARY_TXT_VISIT_DATE}     ${visit_date}
    Element Text Should Be    ${SUMMARY_TXT_COMMENT}        ${comment}
