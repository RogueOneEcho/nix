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
  version = "14.8.0.1";
in
stdenv.mkDerivation {
  pname = "sox-ng";
  inherit version;

  src = fetchurl {
    url = "https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${version}.tar.gz";
    hash = "sha256-LyillnYJB+xvwSPTMI2VSyw1mKXLo1ZFlfV8+F2NyJY=";
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
