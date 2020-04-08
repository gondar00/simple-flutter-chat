package com.example.e_doctor

import android.webkit.URLUtil

object OpenTokConfig {
    // *** Fill the following variables using your own Project info from the OpenTok dashboard  ***
    // ***                      https://dashboard.tokbox.com/projects                           ***

    // Replace with your OpenTok API key
    val API_KEY = "46649052"
    // Replace with a generated Session ID
    val SESSION_ID = "1_MX40NjY0OTA1Mn5-MTU4NjEwNTc3NTU2NX53Y0ltUVBWSzFSQTJUTm40czRmYjBpWTJ-fg"
    // Replace with a generated token (from the dashboard or using an OpenTok server SDK)
    val TOKEN = "T1==cGFydG5lcl9pZD00NjY0OTA1MiZzaWc9ODExNzRjMjRkODRhMGM2YzMyYzc2YjU3NTMyYWUyOWQ1MmNjN2RlZDpzZXNzaW9uX2lkPTFfTVg0ME5qWTBPVEExTW41LU1UVTROakV3TlRjM05UVTJOWDUzWTBsdFVWQldTekZTUVRKVVRtNDBjelJtWWpCcFdUSi1mZyZjcmVhdGVfdGltZT0xNTg2MTA1ODAyJm5vbmNlPTAuMjQ2OTYwMjgzNjkzNzYxJnJvbGU9cHVibGlzaGVyJmV4cGlyZV90aW1lPTE1ODY3MTA2MDEmaW5pdGlhbF9sYXlvdXRfY2xhc3NfbGlzdD0="

    /*                           ***** OPTIONAL *****
     If you have set up a server to provide session information replace the null value
     in CHAT_SERVER_URL with it.
     For example: "https://yoursubdomain.com"
    */
    val CHAT_SERVER_URL: String? = null
    val SESSION_INFO_ENDPOINT = CHAT_SERVER_URL?:"" + "/session"


    // *** The code below is to validate this configuration file. You do not need to modify it  ***

    lateinit var webServerConfigErrorMessage: String
    lateinit var hardCodedConfigErrorMessage: String

    val isWebServerConfigUrlValid: Boolean
        get() {
            if (OpenTokConfig.CHAT_SERVER_URL == null || OpenTokConfig.CHAT_SERVER_URL.isEmpty()) {
                webServerConfigErrorMessage = "CHAT_SERVER_URL in OpenTokConfig.java must not be null or empty"
                return false
            } else if (!(URLUtil.isHttpsUrl(OpenTokConfig.CHAT_SERVER_URL) || URLUtil.isHttpUrl(OpenTokConfig.CHAT_SERVER_URL))) {
                webServerConfigErrorMessage = "CHAT_SERVER_URL in OpenTokConfig.java must be specified as either http or https"
                return false
            } else if (!URLUtil.isValidUrl(OpenTokConfig.CHAT_SERVER_URL)) {
                webServerConfigErrorMessage = "CHAT_SERVER_URL in OpenTokConfig.java is not a valid URL"
                return false
            } else {
                return true
            }
        }

    fun areHardCodedConfigsValid(): Boolean {
        if (OpenTokConfig.API_KEY != null && !OpenTokConfig.API_KEY.isEmpty()
                && OpenTokConfig.SESSION_ID != null && !OpenTokConfig.SESSION_ID.isEmpty()
                && OpenTokConfig.TOKEN != null && !OpenTokConfig.TOKEN.isEmpty()) {
            return true
        } else {
            hardCodedConfigErrorMessage = "API KEY, SESSION ID and TOKEN in OpenTokConfig.java cannot be null or empty."
            return false
        }
    }
}