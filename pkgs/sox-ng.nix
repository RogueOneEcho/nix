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
  version = "14.7.0.7";
in
stdenv.mkDerivation {
  pname = "sox-ng";
  inherit version;

  src = fetchurl {
    url = "https://codeberg.org/sox_ng/sox_ng/archive/sox_ng-${version}.tar.gz";
    hash = "sha256-V7FdDIlR7YQEPX1IR83yTH/O+HqLp0B2+JgOZtWO+b4=";
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
