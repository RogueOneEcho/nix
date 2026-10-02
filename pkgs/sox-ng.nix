{
  lib,
  stdenv,
  fetchzip,
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

  src = fetchzip {
    url = "https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${version}.tar.gz";
    hash = "sha256-dHyDbMYvydC7ayG0n+RXK59w1vMTsi6y9jsYHBppC9k=";
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
