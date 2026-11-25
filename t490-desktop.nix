# t490-desktop.nix — Home Manager module
#
# Converted from:
#   ~/.config/umbriel/config.toml        -> programs.umbriel.settings
#   noctalia full config                 -> programs.noctalia.settings
#   ~/.config/starship.toml              -> programs.starship.settings
#   fastfetch config.jsonc               -> programs.fastfetch.settings
#   fastfetch.sh                         -> `fastfetch.sh` on PATH
#
# Needs `inputs` in home-manager.extraSpecialArgs. If your flake already imports
# the umbriel/noctalia homeModules elsewhere (e.g. common.nix), delete `imports`.
{ config, lib, pkgs, inputs, ... }:
let
  home = config.home.homeDirectory;

  # T490 internal panel. FHD model assumed — WQHD model: "2560x1440@60".
  # (Your old block was the P14s panel: 2560x1600, scale 1.45, HDR/VRR.)
  panel = {
    mode = "1920x1080@60";
    position = [ 0 0 ];
    scale = 1.0;
  };

  fastfetchScript = pkgs.writeShellScriptBin "fastfetch.sh" ''
    export PATH=${lib.makeBinPath (with pkgs; [ fastfetch imagemagick bc ncurses coreutils ])}:$PATH
    # Path to the image file
    #IMAGE_PATH="$HOME/.local/share/fastfetch/logos/asukaDress.txt"

    # Check if the image exists
    if [ ! -f "$IMAGE_PATH" ]; then
        # Fetch system information without logo
        fastfetch -c ${config.xdg.configHome}/fastfetch/config.jsonc
        exit 0
    else
        # Get the image dimensions
        DIMENSIONS=$(identify -format "%wx%h" "$IMAGE_PATH")

        # Extract width and height
        WIDTH=$(echo "$DIMENSIONS" | cut -d'x' -f1)
        HEIGHT=$(echo "$DIMENSIONS" | cut -d'x' -f2)

        # Calculate the aspect ratio
        RATIO=$(echo "scale=2; $WIDTH/$HEIGHT" | bc)

        # Ensure COLUMNS is set
        COLUMNS=''${COLUMNS:-$(tput cols)}

        ARGUMENTS=""

        # Determine fetch arguments based on ratio
        if (($(echo "$RATIO >= 1" | bc -l))); then
            ARGUMENTS="--logo-width $(echo "$COLUMNS / 2.5" | bc)"
        else
            ARGUMENTS="--logo-height 21"
        fi

        # Fetch system information with adjusted logo size
        fastfetch --logo ${home}/.local/share/fastfetch/logos/asukaDress.txt -c ${config.xdg.configHome}/fastfetch/config.jsonc
    fi
  '';
in
{
  imports = [
    inputs.umbriel.homeModules.default
    inputs.noctalia.homeModules.default
  ];

  # ── Umbriel ──────────────────────────────────────────────────────────────
  programs.umbriel = {
    enable = true;
    settings = {
      general = {
        autostart = [ "noctalia" "proton-bridge-core" ];
        mod_key = "Super";
        xwayland = true;
        xwayland_native_resolution = true;
        xwayland_xsettings = false;
        attach_modal_dialogs = true;
      };
      events = {
        lid_close = "umbriel msg output-disable eDP-1";
        lid_open = "umbriel msg output-enable eDP-1";
      };
      output.eDP-1 = panel;
      input = {
        keyboard = {
          numlock_toggle = true;
          layout = "us";
          options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
        };
        touchpad = {
          enabled = true;
          tap = true;
          tap_and_drag = false;
          natural_scroll = true;
          left_handed = false;
          accel_profile = "adaptive";
          sensitivity = 0.5;
          scroll_factor = 1.5;
          disable_while_typing = true;
          scroll_method = "two_finger";
          click_method = "clickfinger";
          tap_button_map = "left_middle_right";
        };
        focus.follows_mouse = "off";
      };
      keybinds = {
        "Mod+Return" = {
          action = "spawn ghostty";
          repeat = false;
        };
        "Mod+M" = {
          action = "spawn noctalia msg panel-toggle launcher";
          repeat = false;
        };
        "Mod+Insert" = "spawn noctalia msg panel-toggle ishan0121/wallpaper-deck:picker";
        "Mod+B" = {
          action = "spawn firefox-developer-edition";
          repeat = false;
        };
        "Mod+L" = {
          action = "spawn MstyStudio";
          repeat = false;
        };
        "Mod+Alt+Insert" = "spawn noctalia msg panel-toggle barrulus/umbriel-shaders:shaders";
        "Mod+S" = {
          action = "spawn spotify";
          repeat = false;
        };
        "Mod+Q" = {
          action = "window-close";
          repeat = false;
        };
        "Mod+End" = "session-quit";
        "Mod+Shift+Escape" = {
          action = "shortcuts-inhibit-toggle";
          allow_when_inhibited = true;
          repeat = false;
        };
        "Mod+Space" = "spawn noctalia msg dock-toggle";
        "Mod+Alt+Home" = {
          action = "spawn noctalia msg panel-toggle control-center";
          repeat = false;
        };
        "Mod+Home" = {
          action = "spawn noctalia msg settings-toggle";
          repeat = false;
        };
        "Mod+Tab".action = "spawn noctalia msg  window-switcher";
        XF86AudioRaiseVolume = {
          action = "spawn noctalia msg volume-up";
          allow_when_locked = true;
        };
        XF86AudioLowerVolume = {
          action = "spawn noctalia msg volume-down";
          allow_when_locked = true;
        };
        XF86AudioMute = {
          action = "spawn noctalia msg volume-mute";
          allow_when_locked = true;
          repeat = false;
        };
        XF86AudioPlay = {
          action = "spawn noctalia msg media toggle";
          allow_when_locked = true;
          repeat = false;
        };
        XF86AudioNext = {
          action = "spawn noctalia msg media next";
          allow_when_locked = true;
        };
        XF86AudioPrev = {
          action = "spawn noctalia msg media previous";
          allow_when_locked = true;
        };
        XF86MonBrightnessUp = {
          action = "spawn noctalia msg brightness-up";
          allow_when_locked = true;
        };
        XF86MonBrightnessDown = {
          action = "spawn noctalia msg brightness-down";
          allow_when_locked = true;
        };
        "Mod+Ctrl+Page_Up" = {
          action = "spawn noctalia msg workspace-move-up";
          repeat = true;
        };
        "Mod+Ctrl+Page_Down" = {
          action = "spawn noctalia msg workspace-move-down";
          repeat = true;
        };
        "Super+Left" = "window-focus-left";
        "Super+Ctrl+Up" = "workspace-previous";
        "Super+Ctrl+Down" = "workspace-next";
        "Mod+Down" = "window-focus-down";
        "Mod+Up" = "window-focus-up";
        "Mod+Right" = "window-focus-right";
        "Mod+Alt+Period" = "window-focus-next";
        "Mod+Ctrl+Left" = "column-move-left";
        "Mod+Shift+Down" = "window-move-down";
        "Mod+Shift+Up" = "window-move-up";
        "Mod+Ctrl+Right" = "column-move-right";
        "Mod+Shift+F" = {
          action = "window-toggle-floating";
          repeat = false;
        };
        "Mod+Shift+T" = {
          action = "window-focus-switch-floating";
          repeat = false;
        };
        "Mod+P" = {
          action = "window-toggle-pinned";
          repeat = false;
        };
        "Mod+Alt+Page_Up" = {
          action = "window-toggle-maximize-to-edges";
          repeat = false;
        };
        "Mod+Page_Up" = {
          action = "window-toggle-fullscreen";
          repeat = false;
        };
        "Mod+F" = {
          action = "window-toggle-maximize";
          repeat = false;
        };
        "Mod+R" = "window-cycle-primary-extent";
        "Mod+Shift+R" = "window-cycle-primary-extent-back";
        "Mod+Minus" = "window-modify-primary-extent -0.02";
        "Mod+Equal" = "window-modify-primary-extent +0.02";
        "Mod+Ctrl+Minus" = "window-modify-secondary-extent -0.02";
        "Mod+Ctrl+Equal" = "window-modify-secondary-extent +0.02";
        "Mod+Comma" = "window-consume-left";
        "Mod+Period" = "window-consume-right";
        "Mod+Ctrl+Comma" = "window-consume-from-left";
        "Mod+Ctrl+Period" = "window-consume-from-right";
        "Mod+W" = {
          action = "column-toggle-tabbed";
          repeat = false;
        };
        "Mod+Alt+Right".action = "column-focus-tab-next";
        "Mod+Alt+Left" = "column-focus-tab-previous";
        "Mod+WheelUp" = "window-focus-left";
        "Mod+WheelDown" = "window-focus-right";
        "Mod+O" = {
          action = "overview-toggle";
          repeat = false;
        };
        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";
        "Mod+Shift+1" = "window-move-to-workspace 1";
        "Mod+Shift+2" = "window-move-to-workspace 2";
        "Mod+Shift+3" = "window-move-to-workspace 3";
        "Mod+Shift+4" = "window-move-to-workspace 4";
        "Mod+Shift+5" = "window-move-to-workspace 5";
        "Mod+Shift+6" = "window-move-to-workspace 6";
        "Mod+Shift+7" = "window-move-to-workspace 7";
        "Mod+Shift+8" = "window-move-to-workspace 8";
        "Mod+Shift+9" = "window-move-to-workspace 9";
        "Mod+Alt+S" = {
          action = "window-move-to-scratchpad music";
          repeat = false;
        };
        "Mod+Alt+Shift+S" = "scratchpad-toggle music";
        "Mod+Alt+E" = {
          action = "window-move-to-scratchpad email";
          repeat = false;
        };
        "Mod+Shift+Alt+E" = "scratchpad-toggle email";
        "Mod+Alt+P" = {
          action = "window-move-to-scratchpad pass";
          repeat = false;
        };
        "Mod+Shift+Alt+P" = "scratchpad-toggle pass";
        "Mod+Alt+M" = {
          action = "window-move-to-scratchpad monitor";
          repeat = false;
        };
        "Mod+Shift+Alt+M" = {
          action = "scratchpad-toggle monitor";
          repeat = false;
        };
      };
      layout = {
        mode = "scrolling";
        extent_presets = [ 0.333 0.5 0.667 ];
        stacking = { };
        scrolling = {
          default_extent_fraction = 0.5;
          center_on_overview_select = false;
        };
      };
      window_rule = [
        {
          blur = true;
        }
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = false;
        }
        {
          match.title = "dev.noctalia.launcher";
          default_position = {
            x = 0;
            y = 0;
            anchor = "bottom";
          };
        }
        {
          corner_radius = 15;
        }
        {
          match.app_id = "^MstyStudio";
          default_maximize = true;
          default_floating = false;
          background_render = true;
        }
        {
          match.app_id = "^com.mitchellh.ghostty";
          default_maximize = true;
          default_floating = false;
        }
        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          default_floating = true;
          default_floating_size_px = {
            width = 800;
            height = 600;
          };
        }
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";
          default_floating = true;
          default_maximize = false;
          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }
        {
          match.title = "^notificationtoasts_.+_desktop";
          default_position = {
            x = 0;
            y = 0;
            anchor = "top_right";
          };
          default_focused = false;
          default_pinned = true;
        }
        {
          match.app_id = "^proton-pass$";
          block_capture = true;
        }
        {
          match.app_id = "^spotify$";
          default_scratchpad = "music";
        }
        {
          match.app_id = "^proton-pass$";
          default_scratchpad = "pass";
        }
        {
          match.is_scratchpad = true;
          border_color_focused = "#E5C07BFF";
          border_color_unfocused = "#5C4A2AFF";
        }
      ];
      scratchpad = [
        {
          name = "music";
          spawn_when_empty = "spotify";
          hide_when_empty = true;
        }
        {
          name = "monitor";
          spawn_when_empty = "ghostty -e btop";
        }
        {
          name = "pass";
          hide_when_empty = true;
          spawn_when_empty = "proton-pass";
        }
        {
          name = "email";
          hide_when_empty = true;
          spawn_when_empty = "thunderbird";
        }
      ];
      layer_rule = [
        {
          match.namespace = "^vicinae$";
          dim_behind = 0.5;
        }
      ];
      # Absolute paths: config.toml becomes a symlink into /nix/store, so
      # relative includes could resolve against the store instead of ~/.config.
      include.optional.files = [
        "${config.xdg.configHome}/umbriel/noctalia-shaders.toml"
        "${config.xdg.configHome}/umbriel/noctalia.toml"
      ];
    };
  };

  # ── Noctalia ─────────────────────────────────────────────────────────────
  # GUI changes still work: they land in ~/.local/state/noctalia/settings.toml
  # and override this file.
  programs.noctalia = {
    enable = true;
    settings = {
      accessibility = {
        high_contrast = false;
        ui_scale = 1.0;
      };
      audio = {
        colorize_icons = false;
        enable_notification_sounds = true;
        enable_overdrive = true;
        enable_power_sounds = true;
        enable_screenshot_sounds = true;
        enable_sounds = true;
        enable_volume_sounds = true;
        sound_theme = "freedesktop";
        sound_volume = 0.5;
        spectrum_frame_rate = 60;
      };
      backdrop = {
        blur_intensity = 0.5;
        enabled = true;
        tint_intensity = 0.3;
      };
      bar = {
        order = [ "Topbar" "sidebar" ];
        Topbar = {
          auto_hide = false;
          auto_hide_delay_ms = 0;
          auto_hide_reserve_space = false;
          background_opacity = 0.84;
          border = "outline_variant";
          border_width = 0.0;
          capsule = false;
          capsule_border_width = 1.0;
          capsule_fill = "surface_container";
          capsule_group = [ ];
          capsule_opacity = 1.0;
          capsule_padding = 6.0;
          capsule_thickness = 0.76;
          center = [ "stack" "rules" ];
          compositor_blur = true;
          concave_edge_corners = true;
          contact_shadow = false;
          enabled = true;
          end = [ "clock" "notifications" "clipboard" "battery" "tray" ];
          font_scale = 1.0;
          font_weight = 500;
          hover_highlight = true;
          layer = "top";
          margin_edge = 0;
          margin_ends = 0;
          margin_opposite_edge = 0;
          padding = 14;
          panel_overlap = 1;
          position = "top";
          radius = 0;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          radius_top_left = 0;
          radius_top_right = 0;
          reserve_space = true;
          scale = 1.0;
          shadow = false;
          show_on_workspace_switch = true;
          show_tooltip = true;
          smart_auto_hide = false;
          start = [ "control-center" "cat" "cat_2" ];
          thickness = 38;
          widget_spacing = 6;
          dead_zone.click_through = false;
        };
        sidebar = {
          auto_hide = false;
          auto_hide_delay_ms = 0;
          auto_hide_reserve_space = false;
          background_opacity = 0.84;
          border = "outline_variant";
          border_width = 0.0;
          capsule = false;
          capsule_border_width = 1.0;
          capsule_fill = "surface_container";
          capsule_group = [ ];
          capsule_opacity = 1.0;
          capsule_padding = 6.0;
          capsule_thickness = 0.76;
          center = [ "taskbar" ];
          compositor_blur = true;
          concave_edge_corners = true;
          contact_shadow = false;
          enabled = true;
          end = [ "session" ];
          font_scale = 1.0;
          font_weight = 500;
          hover_highlight = true;
          layer = "top";
          margin_edge = 0;
          margin_ends = 0;
          margin_opposite_edge = 0;
          padding = 14;
          panel_overlap = 1;
          position = "left";
          radius = 0;
          radius_bottom_left = 0;
          radius_bottom_right = 0;
          radius_top_left = 0;
          radius_top_right = 80;
          reserve_space = true;
          scale = 1.0;
          shadow = false;
          show_on_workspace_switch = true;
          show_tooltip = true;
          smart_auto_hide = false;
          start = [ "audio_visualizer" "media" ];
          thickness = 34;
          widget_spacing = 6;
          dead_zone.click_through = false;
        };
      };
      battery.warning_threshold = 10;
      bluetooth = {
        connect_when_enabled = false;
        connection_notifications = false;
      };
      brightness = {
        enable_ddcutil = false;
        enable_scheduled_brightness = false;
        ignore_mmids = [ ];
        minimum_brightness = 0.0;
        scheduled_day_brightness = 1.0;
        scheduled_night_brightness = 0.5;
        sync_all_monitors = false;
      };
      calendar = {
        dedupe_events = false;
        dedupe_ignore_patterns = [ ];
        enabled = false;
        event_date_format = "%A %e %B";
        event_time_format = "%H:%M";
        refresh_minutes = 15;
        reminders = {
          all_day_digest_time = "09:00";
          default_lead_minutes = 10;
          enabled = true;
          use_event_reminders = true;
        };
      };
      control_center = {
        hidden_tabs = [ ];
        show_avatar_border = true;
        show_session_button = true;
        show_shortcut_labels = true;
        sidebar = "compact";
        sidebar_section = "full";
        width = 700;
        calendar = {
          hide_past_events = false;
          past_events_threshold_minutes = 30;
          show_events_card = true;
          show_events_location = false;
          show_week_numbers = false;
        };
        media.show_visualizer = true;
        shortcuts = [
          {
            type = "wifi";
          }
          {
            type = "bluetooth";
          }
          {
            type = "caffeine";
          }
          {
            type = "notification";
          }
          {
            type = "vn1k/cursor:shortcut";
          }
          {
            type = "power_profile";
          }
        ];
      };
      desktop_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000002"
          "desktop-widget-0000000000000003"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          desktop-widget-0000000000000001 = {
            box_height = 160.0;
            box_width = 592.0;
            cx = 360.0;
            cy = 224.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              font_family = "3270 Nerd Font SemCond";
              format = "{:%-I:%M %p}";
            };
          };
          desktop-widget-0000000000000002 = {
            box_height = 64.0;
            box_width = 432.0;
            cx = 256.0;
            cy = 912.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "label";
            settings = {
              background = false;
              color = "surface";
              font_family = "VictorMono NFP Medium Obl";
              opacity = 1.0;
              title = "See you space Cowboy...";
            };
          };
          desktop-widget-0000000000000003 = {
            box_height = 192.0;
            box_width = 1536.0;
            cx = 768.0;
            cy = 864.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "audio_visualizer";
            settings = {
              background = false;
              bands = 84;
              centered = false;
              show_wave = true;
              show_when_idle = true;
            };
          };
        };
      };
      dock = {
        active_monitor_only = true;
        active_opacity = 1.0;
        active_scale = 1.0;
        auto_hide = false;
        auto_hide_reveal_delay_ms = 250;
        background_opacity = 0.78999996;
        border = "outline_variant";
        border_width = 1.0;
        colorize_icons = false;
        compositor_blur = true;
        concave_edge_corners = true;
        cross_axis_padding = 8;
        enabled = true;
        icon_saturation = 1.0;
        icon_shadow = false;
        icon_size = 48;
        inactive_opacity = 0.85;
        inactive_scale = 0.85;
        item_spacing = 6;
        launcher_custom_image = "${home}/.local/share/icons/candy-icons/apps/scalable/distributor-logo-archbang.svg";
        launcher_custom_image_colorize = false;
        launcher_icon = "grid-dots";
        launcher_position = "start";
        layer = "top";
        magnification = true;
        magnification_scale = 1.45;
        main_axis_padding = 16;
        margin_edge = 0;
        margin_ends = 0;
        pinned = [
          "firefox-developer-edition"
          "MstyStudio"
          "com.mitchellh.ghostty"
          "postbird"
          "librewolf"
        ];
        position = "left";
        radius = 80;
        radius_bottom_left = 80;
        radius_bottom_right = 80;
        radius_top_left = 80;
        radius_top_right = 80;
        reserve_space = false;
        shadow = true;
        show_dots = true;
        show_instance_count = true;
        show_running = true;
        smart_auto_hide = true;
      };
      hooks = {
        battery_charging = [ "noctalia msg notify-send 'Sybell System is charging'" ];
        battery_discharging = [ "noctalia msg notify-send 'Sybell System is running off its battery'" ];
        battery_percentage_changed = [ ];
        battery_plugged = [ "noctalia msg notify-send 'Sybell System internal battery charge is full'" ];
        bluetooth_disabled = [ "noctalia msg motify-send 'Bluetooth disabled'" ];
        bluetooth_enabled = [ "noctalia msg notify-send 'Bluetooth enabled'" ];
        colors_changed = [ "noctalia msg notify-send 'Color palette changed'" ];
        logging_out = [ "noctalia msg notify-send 'Goodbye, gonzo'" ];
        power_profile_changed = [ "noctalia msg notify-send 'Sybell System power profile changed'" ];
        rebooting = [ "noctalia msg notify-send 'Sybell System is now rebooting'" ];
        session_locked = [ "noctalia msg notify-send 'Sybell System is locked'" ];
        session_unlocked = [ "noctlalia msg notify-send 'Sybell System unlocking'" ];
        shutting_down = [ "noctalia msg notify 'Sybell System is shutting down'" ];
        started = [ "noctalia msg notify-send 'Welcome Gonzo'" ];
        theme_mode_changed = [ "noctalia msg notify-send 'Noctalia theme has changed'" ];
        wallpaper_changed = [ "noctalia msg notify-send 'Wallpaper changed: $NOCTALIA_WALLPAPER_PATH'" ];
        wifi_disabled = [ "noctalia msg notify-send 'Wifi disabled'" ];
        wifi_enabled = [ "noctalia msg notify-send 'Wifi enabled'" ];
      };
      hot_corners = {
        delay_ms = 0;
        enabled = false;
        bottom_left = {
          action = "none";
          command = "";
        };
        bottom_right = {
          action = "none";
          command = "";
        };
        top_left = {
          action = "none";
          command = "";
        };
        top_right = {
          action = "none";
          command = "";
        };
      };
      idle = {
        behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
        pre_action_fade_seconds = 2.0;
        behavior = {
          lock = {
            action = "lock";
            command = "";
            enabled = true;
            locked_timeout = 0.0;
            resume_command = "";
            timeout = 600.0;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            command = "";
            enabled = true;
            locked_timeout = 0.0;
            resume_command = "";
            timeout = 900.0;
          };
          screen-off = {
            action = "screen_off";
            command = "";
            enabled = true;
            locked_timeout = 0.0;
            resume_command = "";
            timeout = 660.0;
          };
        };
      };
      keybinds = {
        cancel = [ "Escape" ];
        category_next = [ "Ctrl+Tab" ];
        category_previous = [ "Ctrl+Shift+ISO_Left_Tab" ];
        copy = [ "Ctrl+c" ];
        delete = [ "Delete" ];
        down = [ "Down" ];
        left = [ "Left" ];
        right = [ "Right" ];
        save = [ "Ctrl+s" ];
        select_all = [ "Ctrl+a" ];
        tab_next = [ "Tab" ];
        tab_previous = [ "Shift+ISO_Left_Tab" ];
        up = [ "Up" ];
        validate = [ "Return" "KP_Enter" "space" ];
      };
      location = {
        address = "owensboro, Ky";
        auto_locate = false;
        custom_schedule = false;
        sunrise = "";
        sunset = "";
      };
      lockscreen = {
        allow_empty_password = false;
        blur_intensity = 0.5;
        blurred_desktop = false;
        dnd = false;
        edge_smoothness = 0.3;
        enabled = true;
        fingerprint = true;
        grace_period_seconds = 0;
        lock_before_suspend = true;
        monitors = [ ];
        tint_color = "surface";
        tint_intensity = 0.3;
        transition = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "zoom"
          "honeycomb"
          "vortex"
          "pixel"
          "diamond"
          "golden"
          "melt"
        ];
        transition_duration = 1500.0;
        wallpaper = "";
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
          "lockscreen-widget-0000000000000004"
          "lockscreen-login-box@winit"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 768.0;
            cy = 778.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_container";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@winit" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 448.0;
            cy = 891.0;
            enabled = true;
            output = "winit";
            placement_height = 1073.0;
            placement_width = 895.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_container";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 176.0;
            box_width = 608.0;
            cx = 768.0;
            cy = 224.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              format = "{:%-I:%M %p}";
            };
          };
          lockscreen-widget-0000000000000002 = {
            box_height = 368.0;
            box_width = 448.0;
            cx = 1328.0;
            cy = 696.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "sticker";
            settings = {
              background = false;
              image_path = "${home}/Pictures/gifs/danceDanceMF.gif";
              opacity = 1.0;
            };
          };
          lockscreen-widget-0000000000000003 = {
            box_height = 368.0;
            box_width = 368.0;
            cx = 208.0;
            cy = 692.0;
            enabled = true;
            flip_x = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "sticker";
            settings = {
              background = false;
              image_path = "${home}/Pictures/gifs/danceDanceMF.gif";
              opacity = 1.0;
            };
          };
          lockscreen-widget-0000000000000004 = {
            box_height = 144.0;
            box_width = 400.0;
            cx = 224.0;
            cy = 224.0;
            enabled = true;
            output = "eDP-1";
            placement_height = 960.0;
            placement_width = 1536.0;
            rotation = 0.0;
            type = "weather";
            settings = { };
          };
        };
      };
      nightlight = {
        enabled = false;
        force = false;
        temperature_day = 6500;
        temperature_night = 4000;
      };
      notification = {
        background_opacity = 0.97;
        border = true;
        border_color = "outline_variant";
        border_width = 1.0;
        collapse_on_dismiss = true;
        colorize_icons = false;
        enable_daemon = true;
        follow_focused_output = false;
        group_by_app = true;
        history_retention_hours = 0;
        keep_dismissed_in_history = true;
        layer = "top";
        max_visible = 0;
        monitors = [ ];
        newest_on_edge = false;
        offset_x = 20;
        offset_y = 8;
        position = "top_right";
        scale = 1.0;
        show_actions = true;
        show_app_name = true;
        show_progress_bar = true;
        width = 360;
      };
      osd = {
        background_opacity = 0.97;
        border = true;
        border_color = "outline_variant";
        border_width = 1.0;
        enabled = true;
        follow_focused_output = false;
        hide_delay_ms = 1400;
        monitors = [ ];
        offset_x = 20;
        offset_y = 8;
        orientation = "horizontal";
        position = "top_right";
        position_vertical = "top_center";
        scale = 1.0;
        kinds = {
          bluetooth = true;
          brightness = true;
          caffeine = true;
          custom = true;
          dnd = true;
          keyboard_backlight = true;
          keyboard_layout = true;
          lock_keys = true;
          media = true;
          media_volume = true;
          nightlight = true;
          power_profile = true;
          privacy = true;
          volume = true;
          volume_input = true;
          volume_output = true;
          wifi = true;
        };
      };
      plugin_settings = {
        "felipeartur/ai-usagebar" = {
          panel_placement = "floating";
          panel_position = "bottom_right";
          show_priorities = true;
        };
        "noctalia/mpvpaper" = {
          picker_position = "center_left";
          run_as_systemd = true;
          video_directory = "${home}/Pictures/live-wallpapers";
        };
      };
      plugins = {
        auto_update = "all";
        enabled = [
          "noctalia/wallhaven"
          "noctalia/bongocat"
          "dotnetrob/cat"
          "thaer99ob/default-apps"
          "tausif/ncs-visualizer"
          "imjustdoingmypart/niri-animations"
          "lucasoe/proton-pass"
          "miguelfm/ai-triage"
          "felipeartur/ai-usagebar"
          "yuuto/calculator"
          "neoscaler/charge-mode"
          "vn1k/cursor"
          "noctalia/kaomoji"
          "setyvii/niri-rules-studio"
          "zhangdm-520/niri-media-idle"
          "luochen1990/niri-ribbon"
          "johnnyp0t/niri-workspace-stack"
          "davemhammer/obsidian"
          "m4sc/profile-switcher"
          "mezoahmedii/quranwidget"
          "miixz/reaction"
          "ishan0121/wallpaper-deck"
          "noctalia/mpvpaper"
          "vn1k/icons"
          "umedbazarov/webapp-maker"
          "marccvictoria/llamanager"
        ];
        source = [
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };
      shell = {
        avatar_path = "${home}/Pictures/gonzo.png";
        button_borders = true;
        card_borders = true;
        circular_avatar = true;
        clipboard_auto_paste = "auto";
        clipboard_confirm_clear_history = true;
        clipboard_enabled = true;
        clipboard_history_max_entries = 100;
        clipboard_image_action_command = "";
        clipboard_keep_from_closed_apps = true;
        corner_radius_scale = 1.0;
        date_format = "%A, %x";
        disable_mipmaps = false;
        external_ip_enabled = true;
        font_family = "AnnotationM NF Obl";
        input_borders = true;
        launch_apps_as_systemd_services = false;
        launch_apps_custom_command = "";
        niri_overview_close_on_launch_enabled = true;
        niri_overview_type_to_launch_enabled = true;
        offline_mode = false;
        password_style = "random";
        polkit_agent = true;
        polkit_colorize_icons = false;
        popup_borders = true;
        popup_shadows = true;
        readline_shortcuts = false;
        screen_time_colorize_icons = false;
        screen_time_enabled = true;
        settings_expand_all_groups = false;
        settings_show_advanced = true;
        settings_window_translucent = false;
        setup_wizard_enabled = true;
        shared_gl_context = true;
        show_close_buttons = true;
        show_location = true;
        telemetry_enabled = true;
        time_format = "{:%H:%M}";
        umbriel_audio_provider_enabled = false;
        umbriel_overview_close_on_launch_enabled = false;
        umbriel_overview_type_to_launch_enabled = false;
        animation = {
          enabled = true;
          speed = 1.0;
        };
        greeter_sync.auto_sync = false;
        keyboard_layout = { };
        launcher = {
          app_grid = false;
          auto_paste = "auto";
          categories = true;
          category_icons_only = true;
          colorize_icons = false;
          compact = false;
          default_view = "recent";
          fetch_exchange_rates = true;
          ignore_mouse = false;
          layout = "full";
          pinned = [ "MstyStudio" "firefox-developer-edition" "spotify-launcher" ];
          provider_prefix = "/";
          search_position = "bottom";
          show_app_actions = true;
          show_app_origin_indicator = true;
          show_icons = true;
          show_navigation_labels = true;
          show_session_button = true;
          show_settings_button = true;
          sort_by_usage = true;
          track_usage = true;
          width = 760;
          dmenu = { };
          panels.ignored = [ "polkit" "setup-wizard" "test" "launcher" ];
          providers = {
            wallpaper = {
              global = true;
              prefix = "";
            };
            windows = {
              global = true;
              prefix = "";
            };
          };
        };
        mpris.blacklist = [ ];
        panel = {
          border_color = "outline_variant";
          border_width = 1.0;
          borders = true;
          clipboard_placement = "floating";
          clipboard_position = "center";
          control_center_placement = "attached";
          control_center_position = "auto";
          floating_layer = "overlay";
          floating_offset = 8;
          launcher_placement = "floating";
          launcher_position = "center";
          list_item_background = false;
          open_near_click_clipboard = false;
          open_near_click_control_center = true;
          open_near_click_launcher = false;
          open_near_click_session = false;
          open_near_click_wallpaper = false;
          polkit_placement = "floating";
          polkit_position = "center";
          session_placement = "attached";
          session_position = "center";
          shadow = true;
          transparency_mode = "glass";
          wallpaper_placement = "attached";
          wallpaper_position = "auto";
          wallpaper_show_names = true;
        };
        privacy = {
          cam_filter_regex = "";
          mic_filter_regex = "";
          screen_filter_regex = "";
        };
        screen_corners = {
          enabled = false;
          size = 32;
        };
        screenshot = {
          annotate = false;
          append_mode_suffix = true;
          close_on_copy = true;
          close_on_save = true;
          confirm_region = true;
          copy_on_close = false;
          copy_to_clipboard = true;
          directory = "${home}/Pictures/screenshot";
          filename_pattern = "";
          format = "png";
          freeze_screen = true;
          pipe_command = "feh";
          pipe_to_command = true;
          quality = 90;
          region_border_width = 2.0;
          region_dim_opacity = 0.65;
          region_modifier = "alt";
          remember_last_region = false;
          save_to_file = true;
          show_cursor = false;
          show_region_dimensions = true;
          show_region_hint = true;
          skip_annotate_on_copy_save = false;
        };
        session = {
          grid = true;
          grid_columns = 2;
          show_shortcuts = true;
          power = { };
          actions = [
            {
              action = "lock";
              command = "";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "";
              label = "";
              lockscreen_shortcut = "";
              shortcut = "1";
              variant = "default";
            }
            {
              action = "logout";
              command = "";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "";
              label = "";
              lockscreen_shortcut = "";
              shortcut = "2";
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              command = "";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "";
              label = "";
              lockscreen_shortcut = "";
              shortcut = "3";
              variant = "default";
            }
            {
              action = "reboot";
              command = "";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "";
              label = "";
              lockscreen_shortcut = "";
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              command = "";
              countdown_seconds = 0.0;
              enabled = true;
              glyph = "";
              label = "";
              lockscreen_shortcut = "";
              shortcut = "5";
              variant = "destructive";
            }
          ];
        };
        shadow = {
          alpha = 0.55;
          direction = "down_left";
        };
        window_switcher = {
          colorize_icons = false;
          current_workspace_only = false;
          mru = false;
          show_all_outputs = true;
          show_app_icon = true;
          show_caption = true;
          show_count = true;
          style = "carousel";
        };
      };
      storage = {
        key_file = "";
        key_source = "secret-service";
      };
      system.monitor = {
        cpu_freq_activity_threshold = 2.5;
        cpu_freq_critical_threshold = 4.5;
        cpu_poll_seconds = 2.0;
        cpu_temp_activity_threshold = 90.0;
        cpu_temp_critical_threshold = 100.0;
        cpu_temp_sensor_path = "";
        cpu_usage_activity_threshold = 85.0;
        cpu_usage_critical_threshold = 100.0;
        disk_free_activity_threshold = 80.0;
        disk_free_critical_threshold = 95.0;
        disk_free_pct_activity_threshold = 80.0;
        disk_free_pct_critical_threshold = 95.0;
        disk_poll_seconds = 10.0;
        disk_used_activity_threshold = 80.0;
        disk_used_critical_threshold = 95.0;
        disk_used_pct_activity_threshold = 80.0;
        disk_used_pct_critical_threshold = 95.0;
        enabled = true;
        gpu_poll_seconds = 5.0;
        gpu_temp_activity_threshold = 60.0;
        gpu_temp_critical_threshold = 85.0;
        gpu_usage_activity_threshold = 50.0;
        gpu_usage_critical_threshold = 95.0;
        gpu_vram_activity_threshold = 50.0;
        gpu_vram_critical_threshold = 90.0;
        memory_poll_seconds = 2.0;
        net_rx_activity_threshold = 1.0;
        net_rx_critical_threshold = 50.0;
        net_tx_activity_threshold = 1.0;
        net_tx_critical_threshold = 50.0;
        network_poll_seconds = 3.0;
        ram_pct_activity_threshold = 60.0;
        ram_pct_critical_threshold = 90.0;
        swap_pct_activity_threshold = 20.0;
        swap_pct_critical_threshold = 80.0;
      };
      theme = {
        builtin = "Noctalia";
        community_palette = "Oxocarbon";
        custom_palette = "home-gonzo-pictures-live-wallpapers-landscape-sea-ships-1920x1080-mp4-fs";
        mode = "dark";
        pure_black_dark = false;
        shell_mode = "dark";
        source = "custom";
        sync_color_scheme = true;
        terminal_colors = "palette";
        wallpaper_scheme = "m3-fruit-salad";
        templates = {
          builtin_ids = [ "btop" "cava" "gtk4" "niri" "qt" ];
          community_ids = [ "yazi" ];
          enable_builtin_templates = true;
          enable_community_templates = true;
        };
      };
      wallpaper = {
        directory = "${home}/Pictures/archWallpapers";
        directory_dark = "";
        directory_light = "";
        edge_smoothness = 0.3;
        enabled = true;
        fill_color = "";
        fill_mode = "crop";
        per_monitor_directories = false;
        sync_transitions = true;
        transition = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "zoom"
          "honeycomb"
          "vortex"
          "pixel"
          "diamond"
          "golden"
          "melt"
        ];
        transition_duration = 1500.0;
        transition_on_startup = false;
        automation = {
          enabled = true;
          interval_seconds = 1800;
          order = "random";
          pause_on_fullscreen = false;
          recursive = false;
        };
      };
      weather = {
        effects = true;
        enabled = true;
        refresh_minutes = 30;
        unit = "imperial";
      };
      widget = {
        active_window = {
          colorize_icons = false;
          display = "icon_only";
          icon_size = 25;
          max_length = 260.0;
          min_length = 80.0;
          title_scroll = "none";
          type = "active_window";
        };
        bar = {
          account = "SybellSystem";
          scroll_repeat = "gesture";
          type = "miguelfm/ai-triage:bar";
          vendor = "ollama";
        };
        bar_2 = {
          extras = "both";
          glyph_position = "after";
          quota_window = "session";
          scale = 1.05;
          show_name = true;
          type = "felipeartur/ai-usagebar:bar";
          vendor = "ollama";
        };
        cat = {
          scale = 1.85;
          type = "dotnetrob/cat:cat";
        };
        cat_2 = {
          scale = 1.85;
          type = "noctalia/bongocat:cat";
        };
        clock = {
          format = "{:%-I:%M %p}";
          type = "clock";
        };
        control-center = {
          custom_image = "${home}/.local/share/icons/Papirus/96x96/apps/distributor-logo-archlinux.svg";
          scale = 1.9000000000000001;
          type = "control-center";
        };
        cpu = {
          stat = "cpu_usage";
          type = "sysmon";
        };
        date = {
          format = "{:%a %d %b}";
          type = "clock";
        };
        input_volume = {
          device = "input";
          type = "volume";
        };
        keyboard_layout = {
          hide_when_single_layout = false;
          type = "keyboard_layout";
        };
        lock_keys = {
          display = "short";
          hide_when_off = false;
          show_caps_lock = true;
          show_num_lock = true;
          show_scroll_lock = false;
          type = "lock_keys";
        };
        media = {
          art_size = 16.0;
          max_length = 220.0;
          min_length = 80.0;
          title_scroll = "none";
          type = "media";
        };
        network_rx = {
          stat = "net_rx";
          type = "sysmon";
        };
        network_tx = {
          stat = "net_tx";
          type = "sysmon";
        };
        output_volume = {
          device = "output";
          type = "volume";
        };
        ram = {
          stat = "ram_used";
          type = "sysmon";
        };
        rules.type = "setyvii/niri-rules-studio:rules";
        spacer = {
          interactive = false;
          type = "spacer";
        };
        stack = {
          max_windows = 7;
          type = "johnnyp0t/niri-workspace-stack:stack";
          visible_workspaces = 4;
        };
        taskbar = {
          colorize_icons = false;
          group_by_workspace = true;
          group_single_icon_per_app = true;
          minimal = true;
          type = "taskbar";
        };
        temp = {
          stat = "cpu_temp";
          type = "sysmon";
        };
        tray = {
          colorize_icons = false;
          drawer = true;
          match_adjacent_spacing = true;
          type = "tray";
        };
        workspaces = {
          colorize_icons = false;
          style = "minimal";
          type = "workspaces";
        };
      };
    };
  };

  # ── Starship ─────────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        ┌────\[$jobs$directory\]───\[$username@$hostname$os\]──>
        ├$git_branch$git_status$character
        └──>>'';
      right_format = "\\[$time\\]";
      continuation_prompt = "▶";
      # Added: without this the palette is defined but never selected, so every
      # neon_* / red_alert / fg0 style fails to parse.
      palette = "noctalia";
      palettes.noctalia = {
        bg1 = "#0d0221";
        bg2 = "#190a2e";
        fg0 = "#e0def4";
        neon_pink = "#ff2e88";
        neon_cyan = "#08f7fe";
        neon_purple = "#b967ff";
        neon_yellow = "#f9f871";
        neon_green = "#09fbd3";
        red_alert = "#ff003c";
        muted_grey = "#5c5470";
      };
      directory = {
        format = "$path";
        style = "bold neon_cyan";
        read_only = "🔒";
        read_only_style = "red_alert";
        truncation_length = 0;
        truncation_symbol = "/";
      };
      git_branch = {
        format = "[$symbol $branch ]($style)";
        symbol = "on ";
        style = "bold neon_purple";
      };
      git_status = {
        format = "[($all_status$ahead_behind)]($style)";
        style = "neon_yellow";
        staged = "✚";
        up_to_date = "✅";
        stashed = "🗄";
        modified = "✺";
        deleted = "✖";
        renamed = "➜";
        untracked = "✳";
        conflicted = "💥";
      };
      jobs = {
        symbol = "✦ ";
        number_threshold = 2;
        symbol_threshold = 1;
        style = "bold neon_cyan";
        format = "[$symbol$number]($style)";
      };
      os = {
        disabled = false; # Added: starship's os module is off by default, so $os rendered nothing.
        format = "[$symbol]($style)";
        style = "neon_cyan";
        symbols.NixOS = "❄";
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐";
        format = "[$hostname](neon_pink)";
      };
      username = {
        show_always = true;
        format = "[$user](neon_purple)";
      };
      character = {
        success_symbol = "[✔](bold neon_green) ";
        error_symbol = "[✘](bold red_alert) ";
      };
      nodejs = {
        format = "[$symbol]($style)";
        symbol = "";
        style = "neon_pink";
      };
      time = {
        disabled = false;
        format = "[$time]($style)";
        time_format = "%I:%M:%p";
        style = "fg0";
        utc_time_offset = "local";
      };
      gcloud = {
        format = "[$symbol]";
        symbol = "☁️";
      };
    };
  };

  # ── Fastfetch ────────────────────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "kitty";
        source = "${home}/.local/share/fastfetch/imgs/unixChanFastech.png";
        height = 28;
        width = 36;
        padding.top = 1;
      };
      display.separator = " ";
      modules = [
        {
          type = "custom";
          format = "  __ _  ___  _ __  _______";
        }
        {
          type = "custom";
          format = " / _` |/ _ \\| '_ \\|_  / _ \\";
        }
        {
          type = "custom";
          format = "| (_| | (_) | | | |/ / (_) |";
        }
        {
          type = "custom";
          format = " \\__, |\\___/|_| |_/___\\___/";
        }
        {
          type = "custom";
          format = " |___/";
        }
        {
          type = "custom";
          format = "| |._ _ |_ ._o _ |";
        }
        {
          type = "custom";
          format = "|_|| | ||_)| |(/_|";
        }
        {
          key = "╭───────────╮";
          type = "custom";
        }
        {
          key = "│   user    {#keys}│";
          type = "title";
          format = "{user-name}";
        }
        {
          key = "│ 󰇅  host    {#keys}│";
          type = "title";
          format = "{host-name}";
        }
        {
          key = "│ {icon}distro  {#keys} │";
          type = "os";
          format = "{pretty-name}";
        }
        {
          key = "│   kernel {#keys}│";
          type = "kernel";
          format = "{release}";
        }
        {
          key = "│ 󰇄  DE/WM  {#keys}│";
          type = "wm";
          format = "{pretty-name}";
        }
        {
          key = "│   terminal{#keys}│";
          type = "terminal";
          format = "{pretty-name} {version}";
        }
        {
          key = "│   shell  {#keys}│";
          type = "shell";
          format = "{pretty-name} {version}";
        }
        {
          key = "│ 󰍛  cpu     {#keys}│";
          type = "cpu";
          format = "{name}";
          showPeCoreCount = true;
        }
        {
          key = "│ 󰍛  gpu     {#keys}│";
          type = "gpu";
          format = "{name}";
        }
        {
          key = "│ 󰉉  disk    {#keys}│";
          type = "disk";
          format = "{size-used} / {size-total} ({size-percentage})";
        }
        {
          key = "│   memory {#keys}│";
          type = "memory";
          format = "{used} / {total} ({percentage})";
        }
        {
          key = "├───────────┤";
          type = "custom";
        }
        {
          type = "media";
          key = "│ ♪ music   {#keys}│";
          format = "{?artist}{artist} - {?}{title}";
          keyColor = "cyan";
        }
        {
          key = "│  colors  {#keys}│";
          type = "colors";
          symbol = "circle";
        }
        {
          key = "╰───────────╯";
          type = "custom";
        }
      ];
    };
  };

  home.packages = [ fastfetchScript ];
}
