# When updating to a newer version, check if the version of `esp32-toolchain-bin.nix` also needs to be updated.
{ rev ? "v5.0-beta1"
, sha256 ? "sha256-qjhzjse86Nnq1JBH24nVXqo+i9Iop4K6lIa3MKYDJrc="
, stdenv
, lib
, fetchFromGitHub
, mach-nix

, idf-component-manager
, esp-coredump
}:

let
  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = rev;
    sha256 = sha256;
    fetchSubmodules = true;
  };

  pythonEnv =
    let
      #requirementsText = builtins.readFile "${src}/tools/requirements/requirements.core.txt";
      # N.B. idf-component-manager has broken version in its requirements
      requirementsText = ''
        setuptools
        click
        pyserial
        future
        cryptography
        pyparsing
        pyelftools
        #idf-component-manager
        esp-coredump
        esptool
        kconfiglib
        freertos_gdb
      '';
    in
    mach-nix.mkPython
      {
        requirements = requirementsText + ''
          construct >= 2.9
        '';
        packagesExtra = [
          idf-component-manager
          esp-coredump
        ];
      };
in
stdenv.mkDerivation rec {
  pname = "esp-idf";
  version = rev;

  inherit src;

  patches = [ ./hack.patch ];

  # This is so that downstream derivations will have IDF_PATH set.
  setupHook = ./setup-hook.sh;

  propagatedBuildInputs = [
    # This is so that downstream derivations will run the Python setup hook and get PYTHONPATH set up correctly.
    pythonEnv.python
  ];

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/

    # Link the Python environment in so that in shell derivations, the Python
    # setup hook will add the site-packages directory to PYTHONPATH.
    ln -s ${pythonEnv}/lib $out/
  '';
}
