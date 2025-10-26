
// Telemetry http://forums.mozillazine.org/viewtopic.php?p=14289125#p14289125
pref("toolkit.telemetry.archive.enabled", false);

// unhide protocol http(s):// in address bar
pref("browser.urlbar.trimURLs", false);

// disable annoying Translation popup
pref("browser.translations.automaticallyPopup", false);
pref("browser.translations.panelShown", false);

// disable "Add Application" bar, https://superuser.com/questions/363827/how-can-i-disable-add-application-for-mailto-links-bar-in-firefox
pref("network.protocol-handler.external.mailto", false);

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

// disable "spnsored" buttons on new tab (it directly contants
// sponsors servers!).
pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// disable DNS prefetch of all your bookmarks:
pref("network.prefetch-next", false);
pref("dom.prefetch_dns_for_anchor_http_document", false);
pref("dom.prefetch_dns_for_anchor_https_document", false);
