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
  version = "__VERSION__";
in
stdenv.mkDerivation {
  pname = "sox-ng";
  inherit version;

  src = fetchurl {
    url = "https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${version}.tar.gz";
    hash = "__SRC_HASH__";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

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
