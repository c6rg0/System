{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = ''
    options snd_hda_intel model=auto,headset-mode-no-hp-mic
  '';

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."99-sample-rate" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 44100 ];
        "default.clock.quantum" = 800;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 1024;
        "resample.quality" = 10;
      };
    };
    wireplumber.extraConfig = { 
      "99-headphone-profile" = {
        "monitor.alsa.rules" = [{
          matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
          actions = {
            update-props = {
              "device.profile" = "output:analog-stereo";
            };
          };
        }];
      };
      "99-disable-suspend" = {
        "monitor.alsa.rules" = [{
          matches = [{
            "node.name" = "~alsa_input.*";
          }{
            "node.name" = "~alsa_output.*";
          }];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }];
      };
      "99-fix-format" = {
        "monitor.alsa.rules" = [{
          matches = [{
            "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
          }];
          actions = {
            update-props = {
              "audio.format" = "S16LE";
            };
          };
        }];
      };
    };
  };
}
