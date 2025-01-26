
// disable annoying Translation popup
pref("browser.translations.automaticallyPopup", false);
pref("browser.translations.panelShown", false);

// disable detectportal.firefox.com
// https://support.mozilla.org/en-US/questions/1157121
pref("network.captive-portal-service.enabled", false);

// disable contile.services.mozilla.com
pref("browser.topsites.contile.enabled", false);

// disable firefox.settings.services.mozilla.com
// IT STILL DOES NOT STOP FIREFOX FROM ACCESSING settings.services!
pref("signon.management.page.breach-alerts.enabled", false);

// disable push.services.mozilla.com
// https://support.mozilla.org/en-US/questions/1261510
pref("dom.push.enabled", false);
pref("dom.push.connection.enabled", false);
pref("dom.push.serverURL", "");

