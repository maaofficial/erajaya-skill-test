*** Settings ***
Documentation      Mobile UI locators repository for Eraspace Application.
...                Contains verified resource-ids and XPaths mapped directly
...                from the live Eraspace Android application.

*** Variables ***
# --- Onboarding / Fresh Launch Locators ---
${ONBOARDING_BTN_NEXT}            id=com.eraspace.app:id/btnNext
${ONBOARDING_BTN_SKIP}            id=com.eraspace.app:id/btnSkip
${ONBOARDING_BTN_CONTINUE}        id=com.eraspace.app:id/btnContinue

# --- Home Dashboard Locators ---
${HOME_CONTAINER_MAIN}            id=com.eraspace.app.home:id/nsvHome
${HOME_BTN_LOGIN_HERO}            id=com.eraspace.app.home:id/btnLogin
${HOME_BTN_REGISTER_HERO}         id=com.eraspace.app.home:id/btnRegister
${HOME_NAV_MENU_LIST}             id=com.eraspace.app.home:id/bnvMain
${HOME_NAV_ITEM_HOME}             id=com.eraspace.app.home:id/navigationHome
${HOME_NAV_ITEM_CATEGORY}         id=com.eraspace.app.home:id/navigationCategory
${HOME_NAV_ITEM_STORE}            id=com.eraspace.app.home:id/navigationStore
${HOME_NAV_ITEM_WISHLIST}         id=com.eraspace.app.home:id/navigationWishlist
${HOME_NAV_ITEM_PROFILE}          id=com.eraspace.app.home:id/navigationProfile

# --- Home Point Section Locators ---
${HOME_CARD_POINT_CONTAINER}      id=com.eraspace.app.home:id/layerPoint
${HOME_TXT_POINT_BALANCE}         id=com.eraspace.app.home:id/tvPoint
${HOME_TXT_CHECK_POINT}           id=com.eraspace.app.home:id/tvCheckPoint

# --- Login Screen Locators ---
${LOGIN_TXT_TOOLBAR}              id=com.eraspace.app:id/tvToolbar
${LOGIN_INPUT_USERNAME}           id=com.eraspace.app.membership:id/edtPhoneNumber
${LOGIN_INPUT_PASSWORD}           id=com.eraspace.app.membership:id/edtPassword
${LOGIN_BTN_SUBMIT}               id=com.eraspace.app.membership:id/btnLogin
${LOGIN_TXT_ERROR_MSG}            id=com.eraspace.app.membership:id/tvError
${LOGIN_BTN_FORGOT_PASSWORD}      id=com.eraspace.app.membership:id/btnForgotPassword

# --- Profile / Akun Tab Locators ---
${PROFILE_TXT_TOOLBAR}            id=com.eraspace.app:id/tvToolbar
${PROFILE_TXT_ACCOUNT_NAME}       id=com.eraspace.app:id/tvName
${PROFILE_TXT_PHONE_NUMBER}       id=com.eraspace.app:id/tvPhoneNumber
${PROFILE_TXT_MEMBER_STATUS}      id=com.eraspace.app:id/tvMemberStatus
${PROFILE_TXT_MY_POINT}           id=com.eraspace.app:id/tvMyPoint
${PROFILE_TXT_MY_VOUCHER}         id=com.eraspace.app:id/tvMyVoucher
${PROFILE_BTN_SETTINGS}           id=com.eraspace.app:id/btnSettings

# --- Settings & Logout Locators ---
${SETTINGS_BTN_LOGOUT}            id=com.eraspace.app.membership:id/btnLogout
${DIALOG_BTN_CONFIRM_LOGOUT}      id=com.eraspace.app:id/btnNegative
${DIALOG_TXT_VERIFY_EMAIL}        xpath=//android.widget.TextView[@resource-id="com.eraspace.app:id/tvTitle" and contains(@text, "Verifikasi Email")]
${DIALOG_BTN_CLOSE}               id=com.eraspace.app:id/btnClose
