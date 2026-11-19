*** Settings ***
Documentation      Operational Page Object keywords for Eraspace Mobile Application.
...                Encapsulates AppiumLibrary actions and references locators.robot.
Library            AppiumLibrary
Resource           ../locators/locators.robot
Variables          ../../config/env_loader.py

*** Variables ***
${DEFAULT_TIMEOUT}         15s
${PLATFORM_NAME}           Android
${APP_PACKAGE}             com.eraspace.app
${APP_ACTIVITY}            com.eraspace.app.presentation.SplashScreenActivity
${AUTOMATION_NAME}         UiAutomator2
${INVALID_USERNAME}        invalid.user@test.com
${INVALID_PASSWORD}        WrongPassword123
${EXPECTED_ERROR_MESSAGE}  Email atau No Handphone belum terdaftar

*** Keywords ***
# --- Application Lifecycle Management ---
Open Eraspace Application
    [Documentation]    Launches the Eraspace app session on Appium Server with device capabilities.
    ...                Uses noReset=False so Appium automatically clears app data/session (force logout)
    ...                and starts the application in a fresh state on every test execution.
    [Arguments]    ${remote_url}=${APPIUM_SERVER_URL}
    ...            ${platform_name}=${PLATFORM_NAME}
    ...            ${device_name}=${DEVICE_NAME}
    ...            ${app_package}=${APP_PACKAGE}
    ...            ${app_activity}=${APP_ACTIVITY}
    ...            ${automation_name}=${AUTOMATION_NAME}
    Open Application    ${remote_url}
    ...                 platformName=${platform_name}
    ...                 deviceName=${device_name}
    ...                 appPackage=${app_package}
    ...                 appActivity=${app_activity}
    ...                 automationName=${automation_name}
    ...                 noReset=${False}
    ...                 autoGrantPermissions=${True}
    Set Appium Timeout    ${DEFAULT_TIMEOUT}
    Dismiss Android Version Info Screen If Present

Close Eraspace Application
    [Documentation]    Closes the current mobile application session.
    Close Application

# --- Helpers ---
Dismiss Android Version Info Screen If Present
    [Documentation]    Handles the 'Anda menggunakan versi Android Terbaru' screen ('Lanjutkan')
    ...                and the Home coachmark tutorial popup ('Lewati') on fresh app launch.
    ${is_info_screen}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ONBOARDING_BTN_NEXT}    timeout=8s
    IF    ${is_info_screen}
        Click Element    ${ONBOARDING_BTN_NEXT}
    END
    ${is_coachmark}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${ONBOARDING_BTN_SKIP}    timeout=8s
    IF    ${is_coachmark}
        Click Element    ${ONBOARDING_BTN_SKIP}
    END

Dismiss Email Verification Popup If Present
    [Documentation]    Dismisses the 'Yuk Verifikasi Email-mu' popup dialog if displayed after login.
    ${is_dialog}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${DIALOG_TXT_VERIFY_EMAIL}    timeout=5s
    IF    ${is_dialog}
        Click Element    ${DIALOG_BTN_CLOSE}
    END

# --- Login Page Actions ---
Navigate To Login Screen
    [Documentation]    Navigates directly from fresh Home screen to Login screen by tapping the Masuk button.
    Wait Until Element Is Visible    ${HOME_BTN_LOGIN_HERO}     timeout=15s
    Click Element                    ${HOME_BTN_LOGIN_HERO}
    Wait Until Element Is Visible    ${LOGIN_INPUT_USERNAME}    timeout=10s

Input Login Credentials
    [Documentation]    Inputs username/phone and password into respective fields.
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${LOGIN_INPUT_USERNAME}    timeout=10s
    Clear Text                       ${LOGIN_INPUT_USERNAME}
    Input Text                       ${LOGIN_INPUT_USERNAME}    ${username}
    Wait Until Element Is Visible    ${LOGIN_INPUT_PASSWORD}    timeout=10s
    Clear Text                       ${LOGIN_INPUT_PASSWORD}
    Input Password                   ${LOGIN_INPUT_PASSWORD}    ${password}
    Click Element    ${LOGIN_TXT_TOOLBAR}

Click Login Button
    [Documentation]    Taps the submit login button.
    Wait Until Element Is Visible    ${LOGIN_BTN_SUBMIT}    timeout=10s
    Click Element                    ${LOGIN_BTN_SUBMIT}

# --- Login Assertions ---
Verify Login Error Message Displayed
    [Documentation]    Verifies that the invalid login error message is visible.
    Wait Until Element Is Visible    ${LOGIN_TXT_ERROR_MSG}    timeout=10s
    ${error_text}=    Get Text       ${LOGIN_TXT_ERROR_MSG}
    Should Contain                   ${error_text}    Email atau No Handphone belum terdaftar

# --- Home Dashboard Assertions ---
Verify Redirected To Homepage
    [Documentation]    Verifies that user is successfully redirected to Homepage dashboard after login.
    Dismiss Email Verification Popup If Present
    Wait Until Element Is Visible    ${HOME_CONTAINER_MAIN}    timeout=15s

Verify Navigation Menu List Displayed
    [Documentation]    Verifies that bottom navigation bar / menu list is displayed on homepage.
    Wait Until Element Is Visible    ${HOME_NAV_MENU_LIST}        timeout=10s
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_HOME}        timeout=5s
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_CATEGORY}    timeout=5s
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_STORE}       timeout=5s
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_WISHLIST}    timeout=5s
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_PROFILE}     timeout=5s

Verify Point Balance List Displayed
    [Documentation]    Verifies that the user point balance container and amount are displayed on homepage.
    Wait Until Element Is Visible    ${HOME_CARD_POINT_CONTAINER}    timeout=10s
    Wait Until Element Is Visible    ${HOME_TXT_POINT_BALANCE}       timeout=10s
    ${points}=    Get Text           ${HOME_TXT_POINT_BALANCE}
    Should Contain              ${points}    0

Verify User Account Name Displayed
    [Documentation]    Verifies that the user account name matches registered name in the Akun/Profile section.
    [Arguments]    ${expected_name}=${EXPECTED_ACCOUNT_NAME}
    Wait Until Element Is Visible    ${HOME_NAV_ITEM_PROFILE}       timeout=10s
    Click Element                    ${HOME_NAV_ITEM_PROFILE}
    ${is_coachmark}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ONBOARDING_BTN_SKIP}    timeout=3s
    IF    ${is_coachmark}
        Click Element    ${ONBOARDING_BTN_SKIP}
    END
    Wait Until Keyword Succeeds      3x    2s     Assert Account Name Text    ${expected_name}
    # Return back to Home tab to complete flow cleanly
    Click Element                    ${HOME_NAV_ITEM_HOME}
    Wait Until Element Is Visible    ${HOME_CONTAINER_MAIN}         timeout=10s

Assert Account Name Text
    [Documentation]    Helper keyword to wait for account name element and verify its text (resilient to DOM re-render).
    [Arguments]    ${expected_name}
    Wait Until Element Is Visible    ${PROFILE_TXT_ACCOUNT_NAME}    timeout=10s
    Element Should Contain Text      ${PROFILE_TXT_ACCOUNT_NAME}    ${expected_name}
