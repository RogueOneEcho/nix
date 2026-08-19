{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  flac,
  lame,
  sox-ng,
  makeBinaryWrapper,
}:
let
  version = "0.31.0";
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
    hash = "sha256-+REt+MKImO7fnYWJ32P6mKzulGJTnxc+9ednVF5aCJU=";
  };

  cargoHash = "sha256-0+vZma8AC44XqVHzmJT/roV7sy8w6DYhujRK9N91J5c=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = runtimeDeps ++ [ cacert ];

  env = {
    CAESURA_NIX = "1";
  };

  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    cat > config.yml <<EOF
    verbosity: trace
    EOF
  '';

  doCheck = false;

  postPatch = ''
    substituteInPlace Cargo.toml crates/core/Cargo.toml crates/macros/Cargo.toml crates/options/Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  postInstall = ''
    wrapProgram $out/bin/caesura \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  doInstallCheck = false;
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
