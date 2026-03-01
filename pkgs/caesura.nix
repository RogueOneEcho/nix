{
  lib,
  rustPlatform,
  fetchFromGitHub,
  flac,
  lame,
  sox-ng,
  makeBinaryWrapper,
}:
let
  version = "0.27.1";
  runtimeDeps = [
    flac
    lame
    sox-ng
  ];
in
rustPlatform.buildRustPackage {
  pname = "caesura";
  inherit version;

  src = fetchFromGitHub {
    owner = "RogueOneEcho";
    repo = "caesura";
    tag = "v${version}";
    hash = "sha256-G6S8e656ocRsvT99Zd2nzhwuiUJYioCOUmt7DCBSyBk=";
  };

  cargoHash = "sha256-fuEVdQpKsy6vEALKQ50WTkTC7mEB4L6lq2dEp5BQBOs=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = runtimeDeps;

  env = {
    CAESURA_NIX = "1";
  };

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

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/caesura version
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
