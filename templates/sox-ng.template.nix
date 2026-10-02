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
  version = "__VERSION__";

  src = fetchFromCodeberg {
    owner = "sox_ng";
    repo = "sox_ng";
    tag = "sox_ng-${finalAttrs.version}";
    hash = "__SRC_HASH__";
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
