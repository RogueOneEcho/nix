{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  flac,
  lame,
  makeBinaryWrapper,
  sox-ng,
}:
let
  runtimeDeps = [
    flac
    lame
    sox-ng
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "caesura";
  version = "__VERSION__";

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${finalAttrs.version}";
    hash = "__SRC_HASH__";
  };

  cargoHash = "__CARGO_HASH__";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ runtimeDeps;

  postPatch = ''
    substituteInPlace Cargo.toml crates/*/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  preCheck = ''
    cat > config.yml <<EOF
    verbosity: trace
    EOF
  '';

  postInstall = ''
    wrapProgram $out/bin/caesura \
      --prefix PATH : ${lib.makeBinPath finalAttrs.passthru.runtimeDeps}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/caesura version --offline
  '';

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "Versatile command line tool for fully automated transcoding of FLAC sources";
    homepage = "https://github.com/RogueOneEcho/caesura";
    license = lib.licenses.agpl3Only;
    mainProgram = "caesura";
  };
})
