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
  version = "0.27.0-alpha.48";
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
    hash = "sha256-66H3g3MLniZh/lnUdpyCyjvr551J8fFEmkoHhNm85oI=";
  };

  cargoHash = "sha256-n6wq/fDKdz19MuNk7s9QPNRs9KKJb8JMKhphFMj+2Kw=";

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
