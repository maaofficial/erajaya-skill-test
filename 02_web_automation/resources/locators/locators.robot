*** Settings ***
Documentation      Locators repository for CURA Healthcare Service web automation.
...                Contains IDs, XPaths, and CSS Selectors for Login and Make Appointment pages.

*** Variables ***
# --- Navigation & Header Locators ---
${NAV_BTN_TOGGLE_MENU}            id=menu-toggle
${NAV_LINK_LOGIN}                 xpath=//a[text()='Login']
${NAV_LINK_LOGOUT}                xpath=//a[text()='Logout']
${NAV_BTN_MAKE_APPOINTMENT}       id=btn-make-appointment

# --- Login Page Locators ---
${LOGIN_INPUT_USERNAME}           id=txt-username
${LOGIN_INPUT_PASSWORD}           id=txt-password
${LOGIN_BTN_SUBMIT}               id=btn-login
${LOGIN_TXT_ERROR_MSG}            css=.text-danger

# --- Make Appointment Page Locators ---
${APPOINTMENT_TXT_HEADER}         xpath=//h2[text()='Make Appointment']
${APPOINTMENT_SELECT_FACILITY}    id=combo_facility
${APPOINTMENT_CHK_READMISSION}    id=chk_hospotal_readmission
${APPOINTMENT_RDO_MEDICARE}       id=radio_program_medicare
${APPOINTMENT_RDO_MEDICAID}       id=radio_program_medicaid
${APPOINTMENT_RDO_NONE}           id=radio_program_none
${APPOINTMENT_INPUT_VISIT_DATE}   id=txt_visit_date
${APPOINTMENT_INPUT_COMMENT}      id=txt_comment
${APPOINTMENT_BTN_BOOK}           id=btn-book-appointment

# --- Appointment Confirmation / Summary Page Locators ---
${SUMMARY_TXT_HEADER}             xpath=//h2[text()='Appointment Confirmation']
${SUMMARY_TXT_FACILITY}           id=facility
${SUMMARY_TXT_READMISSION}        id=hospital_readmission
${SUMMARY_TXT_PROGRAM}            id=program
${SUMMARY_TXT_VISIT_DATE}         id=visit_date
${SUMMARY_TXT_COMMENT}            id=comment
${SUMMARY_BTN_GO_TO_HOMEPAGE}     xpath=//a[text()='Go to Homepage']
