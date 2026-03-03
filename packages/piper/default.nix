{
  supportedSystems,
  system,

  lib,

  buildGoModule,
  fetchFromGitHub
}: lib.warn ''
    ⚠️ This package has flaky tests. You may need to rerun the build several times.

    ⚠️ The repository for this package will be archived on 2026-12-31, see
    <https://github.com/SAP/jenkins-library/blob/f1663c2d50b7229f7c12a8bb8b74f94d6c6fcc4a/README.md?plain=1#L1-L3>.
''
    buildGoModule rec {
      pname = "Piper";
      version = "1.495.0";

      src = fetchFromGitHub {
        owner = "SAP";
        repo = "jenkins-library";
        # Use precise id to be robust against re-tagging;
        # rev = "v${version}";
        rev = "f1663c2d50b7229f7c12a8bb8b74f94d6c6fcc4a";
        hash = "sha256-a6kRhp5SYJdl+Cn2ueTGqRLATgnChDVQsSpWtO+oUJo=";
      };
      vendorHash = {
        aarch64-darwin = "sha256-hWEoUX0dCF+BqrLGRdIZxGFa78XVal2F8KjklNGJ+Tc=";
        x86_64-linux = "sha256-eyDhvrATb2d6EH/KxGiKjMLUFhze/VKXPwcE63VNwOg=";
      }.${system};

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
