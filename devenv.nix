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
    (k3d.override {
      k3sVersion = "1.32.1-k3s1";
    })
    k3s
    tektoncd-cli
    openshift
    act
    openssl
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
  processes."webui".exec = "gunicorn --workers=1 --certfile=certs/cert.pem --keyfile=certs/key.pem --bind 0.0.0.0:5000 --log-level=info service:app";

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  enterShell = ''
    git --version
    export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
  '';

  # https://devenv.sh/tasks/
  tasks = {
    "certs:setup" = {
      exec = "mkdir -p certs; ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -nodes -keyout certs/key.pem -out certs/cert.pem -days 365 -subj \"/C=US/ST=Dev/L=Local/O=LocalDev/OU=Dev/CN=localhost\"";
      status = "ls certs/cert.pem certs/key.pem";
    };
    "devenv:enterShell".after = ["certs:setup"];
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    nosetests
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
