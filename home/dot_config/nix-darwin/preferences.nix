{ config, lib, ... }:

let
  user = config.system.primaryUser;
  asUser = cmd: ''launchctl asuser "$(id -u -- ${user})" sudo --user=${user} -- ${cmd}'';
in
{
  system.defaults = {
    ##################################################
    # General UI/UX, Keyboard, Trackpad, Finder
    ##################################################
    NSGlobalDomain = {
      NSTableViewDefaultSizeMode = 1;
      AppleShowScrollBars = "Always";

      # Set a blazingly fast keyboard repeat rate
      KeyRepeat = 2;
      InitialKeyRepeat = 13;

      # Enable full keyboard access for all controls
      # (e.g. enable Tab in modal dialogs)
      AppleKeyboardUIMode = 3;

      # enable tap to click
      "com.apple.mouse.tapBehavior" = 1;

      # three finger
      AppleEnableSwipeNavigateWithScrolls = false;

      # cursor speed
      "com.apple.trackpad.scaling" = 5.0;

      # show all file extension
      AppleShowAllExtensions = true;
    };

    ##################################################
    # Dock
    ##################################################
    # persistent-apps is intentionally unmanaged to keep apps pinned by hand.
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      mineffect = "scale";
      mru-spaces = false;
      show-recents = false;
      tilesize = 55;
    };

    ##################################################
    # Trackpad
    ##################################################
    # Written to both the built-in and Bluetooth trackpad domains.
    trackpad = {
      Clicking = true;
      Dragging = true;
      TrackpadThreeFingerHorizSwipeGesture = 1;
    };

    ##################################################
    # Finder
    ##################################################
    # show hidden files
    finder.AppleShowAllFiles = true;

    ##################################################
    # Statusbar
    ##################################################
    # show date and day of week in 24-hour format
    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 0;
      ShowDayOfWeek = true;
    };

    # show battery percentage
    controlcenter.BatteryShowPercentage = true;

    CustomUserPreferences = {
      "com.apple.screensaver".idleTime = 0;
      "com.apple.systemuiserver"."NSStatusItem Visible com.apple.menuextra.clock" = true;
      "com.apple.menuextra.battery".ShowPercent = "YES";

      # disable to create .DS_Store files
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;
    };
  };

  system.activationScripts.postActivation.text = ''
    # enable tap to click for the login screen
    ${asUser "defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1"}

    ###############################################################################
    # Energy saving
    ###############################################################################

    # Disable hibernatemode
    pmset -a \
      standby 0 \
      hibernatemode 0 \
      highstandbythreshold 0 \
      standbydelaylow 86400 \
      standbydelayhigh 86400

    # Disable to write sleepimage
    if [ -e /private/var/vm/sleepimage ]; then
      chflags nouchg /private/var/vm/sleepimage
    fi
    rm -f /private/var/vm/sleepimage
    touch /private/var/vm/sleepimage
    chflags -f uchg /private/var/vm/sleepimage

    # Disable disksleep
    pmset -a disksleep 0

    # On battery
    pmset -b \
      sleep 10 \
      displaysleep 10 \
      powernap 0

    # While charging
    pmset -c \
      sleep 0 \
      displaysleep 0 \
      powernap 1 \
      womp 1

    # nix-darwin restarts Dock only. Restart other affected applications.
    killall -qu ${lib.escapeShellArg user} Finder SystemUIServer || true
  '';
}
