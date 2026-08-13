{
  supportedSystems,

  lib,

  buildGoModule,
  fetchFromGitHub
}: buildGoModule rec {
  pname = "Cloud MTA Build Tool";
  version = "1.2.49";

  src = fetchFromGitHub {
    owner = "SAP";
    repo = "cloud-mta-build-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-Se9+21rKMgmJ5tmvFiXQRfCIs/azYzBkNM0Nbibfo4A=";
  };
  vendorHash = "sha256-vKHMSGncX3NjiS+htqBG+WCZdIRqx0rlsrTV+kfk7R8=";

  ldflags = ["-s" "-w" "-X main.Version=${version}"];

  doCheck = false;

  preBuild = ''
    printf 'cli_version: %s\nmakefile_version: 0.0.1\n' "${version}" > configs/version.yaml
    go generate ./generator.go
  '';

  postInstall = ''
    pushd "''${out}/bin" &> /dev/null
    ln --symbolic 'cloud-mta-build-tool' 'mbt'
    popd
  '';

  meta = with lib; {
    description = "Multi-Target Application (MTA) build tool for Cloud Applications";
    homepage = "https://sap.github.io/cloud-mta-build-tool";
    license = licenses.asl20;
    changelog = "https://github.com/SAP/cloud-mta-build-tool/releases/tag/v${version}";
    platforms = supportedSystems;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
