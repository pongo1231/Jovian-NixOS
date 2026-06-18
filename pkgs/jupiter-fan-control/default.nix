{ lib, stdenv, python3, fetchFromGitHub }:

stdenv.mkDerivation(finalAttrs: {
  pname = "jupiter-fan-control";
  version = "20260422.2";

  src = fetchFromGitHub {
    owner = "Jovian-Experiments";
    repo = "jupiter-fan-control";
    rev = finalAttrs.version;
    hash = "sha256-U/Gu91UaczUCdG3RpFrmD67N3le8E+SHKIlwnSheHKE=";
  };

  buildInputs = [
    (python3.withPackages (py: with py; [
      pyyaml
    ]))
  ];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace usr/share/jupiter-fan-control/fancontrol.py \
      --replace-fail 'if test_name == name:' 'if test_name.startswith(name):'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r usr/share/jupiter-fan-control $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Steam Deck (Jupiter) userspace fan controller";

    # PKGBUILD says MIT, but PID.py is licensed under GPLv3+
    license = licenses.gpl3Plus;
  };
})
