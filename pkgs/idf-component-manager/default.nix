{ stdenv, fetchFromGitHub, mach-nix }:

mach-nix.buildPythonPackage rec {
  pname = "idf-component-manager";
  version = "1.1.4";
  src = fetchFromGitHub {
    owner = "espressif";
    repo = "idf-component-manager";
    rev = "v${version}";
    sha256 = "sha256-WCs2xffnvioL5oxo3/drlgMmLRkkjVGZEJCC00MlQjM=";
  };
  requirements = ''
    cachecontrol[filecache]>0.12.6
    click>=8.0.0;python_version>="3.6"
    colorama
    contextlib2>0.6.0
    future
    pyyaml>5.2
    requests<3
    requests-file
    requests-toolbelt
    schema
    six
    tqdm<5
  '';
}

