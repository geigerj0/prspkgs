{
  supportedSystems,

  lib,

  buildGoModule,
  fetchFromGitHub
}: buildGoModule rec {
  pname = "CF Deploy Plugin";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "multiapps-cli-plugin";
    rev = "v${version}";
    hash = "sha256-yKDFootkizkUexi644ubEsLm+f5ps/VRFTimhVnKhv8=";
  };
  vendorHash = "sha256-MKAEmW3ox5T6L88dc41FAfLZRKp6EQnbfd7YWAy7KGY";

  env.CGO_ENABLED = 0;
  ldflags = ["-w -X main.Version=${version}"];

  meta = with lib; {
    description = "A CLI plugin for Multi-Target Application (MTA) operations in Cloud Foundry";
    longDescription = ''
      This is a Cloud Foundry CLI plugin (formerly known as CF MTA Plugin) for performing
      operations on
      [Multitarget Applications (MTAs)](<https://www.sap.com/documents/2021/09/66d96898-fa7d-0010-bca6-c68f7e60039b.html>)
      in Cloud Foundry, such as deploying, removing, viewing, etc. It is a client for the
      [CF MultiApps Controller](<https://github.com/cloudfoundry-incubator/multiapps-controller>)
      (known also as CF MTA Deploy Service), which is an MTA deployer implementation for Cloud
      Foundry. The business logic and actual processing of MTAs happens into
      CF MultiApps Controller backend.
    '';
    homepage = "https://github.com/cloudfoundry/multiapps-cli-plugin";
    license = licenses.asl20;
    changelog = "https://github.com/cloudfoundry/multiapps-cli-plugin/releases/tag/v${version}";
    platforms = supportedSystems;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
