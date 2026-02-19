{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  flac,
  lame,
  libmad,
  libid3tag,
  libogg,
  libvorbis,
  libsndfile,
  libopus,
  opusfile,
  wavpack,
  libpng,
}:
let
  version = "14.7.0.9";
in
stdenv.mkDerivation {
  pname = "sox-ng";
  inherit version;

  src = fetchurl {
    url = "https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${version}.tar.gz";
    hash = "sha256-k50u+HjnXhKzhZDWjyQAoR1OrQU5k/7W3WFlsl9v0TM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  doCheck = true;

  buildInputs = [
    flac
    lame
    libmad
    libid3tag
    libogg
    libvorbis
    libsndfile
    libopus
    opusfile
    wavpack
    libpng
  ];

  meta = {
    description = "Sound eXchange - maintained fork of SoX";
    homepage = "https://codeberg.org/sox_ng/sox_ng";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sox_ng";
  };
}
