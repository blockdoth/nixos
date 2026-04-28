{ config, ... }:
{
  "browser.download.lastDir" = "~/downloads";
  "browser.toolbars.bookmarks.visibility" = "never";
  "browser.urlbar.placeholderName.private" = "DuckDuckGo";
  "media.videocontrols.picture-in-picture.enabled" = true;
  "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
  "services.sync.username" = config.modules.core.secrets.mails.personal;
  "uc.superpins.border" = "both";
  "zen.urlbar.behavior" = "float";
  "zen.view.compact.enable-at-startup" = true;
  "zen.view.use-single-toolbar" = false;
  "zen.welcome-screen.seen" = true;
  "zen.workspaces.continue-where-left-off" = true;
}
