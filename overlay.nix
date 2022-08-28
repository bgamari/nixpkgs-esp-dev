final: prev:
let
  # mach-nix is used to set up the ESP-IDF Python environment.
  mach-nix-src = prev.fetchFromGitHub {
    owner = "DavHau";
    repo = "mach-nix";
    rev = "6cd3929b1561c3eef68f5fc6a08b57cf95c41ec1";
    hash = "sha256-BRz30Xg/g535oRJA3xEcXf0KM6GTJPugt2lgaom3D6g=";
  };

  mach-nix = import mach-nix-src {
    #pypiDataRev = "315bd2515776ba3b70a05059c603df37e9669d12";
    #pypiDataSha256 = "sha256:1a85adz40ibr6kfs3yz59qfypaylrsn1vmk3dj4fm2jbwhzakcg3";
    pkgs = final;
  };
in
{
  inherit mach-nix;

  # ESP32C3
  gcc-riscv32-esp32c3-elf-bin = prev.callPackage ./pkgs/esp32c3-toolchain-bin.nix { };
  # ESP32
  gcc-xtensa-esp32-elf-bin = prev.callPackage ./pkgs/esp32-toolchain-bin.nix { };
  openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };

  esp-coredump = prev.pythonPackages.callPackage ./pkgs/esp-coredump { inherit mach-nix; };
  idf-component-manager = prev.pythonPackages.callPackage ./pkgs/idf-component-manager { inherit mach-nix; };
  esp-idf = prev.callPackage ./pkgs/esp-idf { inherit mach-nix; inherit (final) idf-component-manager esp-coredump; };

  # ESP8266
  gcc-xtensa-lx106-elf-bin = prev.callPackage ./pkgs/esp8266-toolchain-bin.nix { };

  # Note: These are currently broken in flake mode because they fetch files
  # during the build, making them impure.
  crosstool-ng-xtensa = prev.callPackage ./pkgs/crosstool-ng-xtensa.nix { };
  gcc-xtensa-lx106-elf = prev.callPackage ./pkgs/gcc-xtensa-lx106-elf { };
}
