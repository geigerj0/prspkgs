{
  supportedSystems,

  lib,

  buildGoModule,
  fetchFromGitHub
}: lib.warn ''
    The repository for this package will be archived on 2026-12-31, see
    <https://github.com/SAP/jenkins-library/blob/f1663c2d50b7229f7c12a8bb8b74f94d6c6fcc4a/README.md?plain=1#L1-L3>.
''
    buildGoModule rec {
      pname = "Piper";
      version = "1.494.0";

      src = fetchFromGitHub {
        owner = "SAP";
        repo = "jenkins-library";
        rev = "v${version}";
        hash = "sha256-s7NLDbPKz8ZeaIF+XumK+SFn0fcRJacCG7IiqNHuaAg=";
      };
      vendorHash = "sha256-hBXsTd3L64H4lbys5DjR0Uv03fsObMX0brx2ueYBwmw=";

      ldflags = [
        "-s"
        "-w"
        "-X github.com/SAP/jenkins-library/cmd.GitTag=v${version}"
      ];

      postInstall = ''
        pushd "''${out}/bin"
          mv jenkins-library piper
          ln --symbolic piper jenkins-library
        popd
      '';
      meta = {
        description = "Jenkins shared library for Continuous Delivery pipelines.";
        homepage = "https://www.project-piper.io";
        license = lib.licenses.asl20;
        changelog = "https://github.com/SAP/jenkins-library/releases/tag/v${version}";
        platforms = supportedSystems;
        sourceProvenance = [ lib.sourceTypes.fromSource ];
      };
    }
