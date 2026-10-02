{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  pkg-config,
  flac,
  lame,
  libid3tag,
  libmad,
  libogg,
  libvorbis,
  libsndfile,
  libopus,
  opusfile,
  libpng,
  wavpack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sox_ng";
  version = "14.8.1";

  src = fetchFromCodeberg {
    owner = "sox_ng";
    repo = "sox_ng";
    tag = "sox_ng-${finalAttrs.version}";
    hash = "sha256-dCpYG9iUS374cedXk2dSO8N4qifLCXqlXfoiyJsxMIo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    flac
    lame
    libid3tag
    libmad
    libsndfile
    libopus
    opusfile
    libpng
    wavpack
    libogg
    libvorbis
  ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    description = "Another Swiss Army Knife of sound processing utilities";
    homepage = "https://codeberg.org/sox_ng/sox_ng";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
