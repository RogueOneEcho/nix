{
  lib,
  rustPlatform,
  fetchFromGitHub,
  flac,
  lame,
  sox,
  makeBinaryWrapper,
}:
let
  version = "0.27.0-alpha.27";
  runtimeDeps = [
    flac
    lame
    sox
  ];
in
rustPlatform.buildRustPackage {
  pname = "caesura";
  inherit version;

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${version}";
    hash = "sha256-aXdKK+AE0r1hFc+OkcXkBCc2DdMgDqnMuLEdvoh66kw=";
  };

  cargoHash = "sha256-T8Olzn8doR1VGdcFv0x32rqQ59j+saGJXs8epCKWKUg=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = runtimeDeps;

  preCheck = ''
    cat > config.yml <<EOF
    verbosity: trace
    EOF
  '';

  postPatch = ''
    substituteInPlace Cargo.toml crates/core/Cargo.toml crates/macros/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  postInstall = ''
    wrapProgram $out/bin/caesura \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    description = "CLI for transcoding FLAC audio and uploading to Gazelle-based trackers";
    homepage = "https://github.com/RogueOneEcho/caesura";
    license = lib.licenses.agpl3Only;
    mainProgram = "caesura";
  };
}
