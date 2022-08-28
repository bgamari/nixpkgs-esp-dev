{ stdenv, fetchFromGitHub, mach-nix }:

mach-nix.buildPythonPackage rec {
  pname = "esp-coredump";
  version = "v1.0";
  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-coredump";
    rev = version;
    sha256 = "sha256-9o0k+FCvuWA8Oo9GCMJgpWCr4mRPMj+kQ5kHMNXmiWI=";
  };
  requirements = ''
    construct~=2.10
    pygdbmi<0.10.0.0
  '';
}
