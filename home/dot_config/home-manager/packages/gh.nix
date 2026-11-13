{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    # The git credential helper is configured in dot_config/git/config.tmpl.
    gitCredentialHelper.enable = false;
    extensions = with pkgs; [
      gh-actions-lock
      gh-poi
    ];
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        web = "repo view --web";
      };
    };
  };
}
