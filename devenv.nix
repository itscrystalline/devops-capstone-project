{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/basics/

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    k3d
    tektoncd-cli
    openshift
    act
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.python = {
    enable = true;
    package = pkgs.python39;
    venv = {
      enable = true;
      requirements = ./requirements.txt;
    };
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  services.postgres = {
    enable = true;
    listen_addresses = "0.0.0.0";
    initialDatabases = [
      {
        name = "postgres";
        user = "postgres";
        pass = "postgres";
      }
    ];
  };

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  enterShell = ''
    git --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    nosetests
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
