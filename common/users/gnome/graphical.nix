{ pkgs, ... }: {
  home-manager.users.gnome = {
    home.packages = with pkgs; [
      postman
    ];

    programs = {
      # KDE apps
      plasma = {
        enable = true;
        overrideConfig = true;

        workspace.colorScheme = "BreezeDark";
      };

      konsole.enable = true;

      # Others
      vesktop.enable = true;
      firefox.enable = true;
      obsidian.enable = true;

      # VSCode
      vscode = {
        enable = true;
        package = pkgs.vscode;

        # Sync extensions via settings sync.
        mutableExtensionsDir = true;
      }
    };
  }
}
