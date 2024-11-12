{ config, pkgs, ... }:

{
  services.mopidy = {
    enable = true;
    extensionPackages = [ ];
    settings = {
      file = {
        enabled = true;
        media_dirs = [ "$XDG_MUSIC_DIR|Music" "~/Downloads|Downloads" ];
      };

      spotify = {
        enabled = true;
        client_id = "TOTALLY_NOT_A_FAKE_CLIENT_ID";
        client_secret = "YOU_CAN_USE_ME_FOR_YOUR_SPOTIFY_PREMIUM_SUBSCRIPTION";
      };
    };
  };

  test.stubs.mopidy = {
    version = "0";
    outPath = null;
    buildScript = ''
      mkdir -p $out/bin
      touch $out/bin/mopidy
      chmod +x $out/bin/mopidy
    '';
  };

  nmt.script = ''
    serviceFile=home-files/.config/systemd/user/mopidy.service
    assertFileExists $serviceFile
    assertPathNotExists home-files/.config/systemd/user/mopidy-scan.service
    assertFileRegex $serviceFile 'X-Restart-Triggers=.*mopidy\.conf'

    assertFileExists home-files/.config/mopidy/mopidy.conf
    assertFileContent home-files/.config/mopidy/mopidy.conf \
        ${./basic-configuration.conf}
  '';
}
