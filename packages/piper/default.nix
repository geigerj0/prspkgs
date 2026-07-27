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
      version = "1.517.0";

      src = fetchFromGitHub {
        owner = "SAP";
        repo = "jenkins-library";
        # Use precise id to be robust against re-tagging;
        # rev = "v${version}";
        rev = "dbd91a04b4357b54d911aa729da98d94ebdfadc5";
        hash = "sha256-ja0FrG3daaELEyJkka1LJ6PIdP2gh/OwbH7sAYnHiTo=";
      };

      # Piper's dependency graph pulls in OS/arch-specific transitive modules
      # (e.g. shoenig/go-m1cpu, lufia/plan9stats, power-devops/perfstat, yusufpapurcu/wmi) via
      # gopsutil. With the default vendoring, `go mod` resolves a *different* module set per
      # GOOS/GOARCH, so a vendorHash computed on Linux fails to match on macOS ("hash mismatch in
      # fixed-output derivation"). Fetching the module proxy cache instead of the resolved/vendored
      # tree keeps the fixed-output hash identical across platforms.
      #
      # For more information, see: <https://nixos.org/manual/nixpkgs/stable/#var-go-proxyVendor>
      proxyVendor = true;
      vendorHash = "sha256-DH5vGup9yrKayZY2OopmvyximNthPKUb90YhvYl2en8=";
      # # As soon as <https://docs.determinate.systems/determinate-nix/linux-builder/> is
      # # functional, the following approach can be used:
      # vendorHash = {
      #   aarch64-darwin = "sha256-0HvWBjS3QaiA8ls/SZiMre6Jr1tNQeA8vp02tVl22+g=";
      #   x86_64-linux = lib.fakeHash;
      # }.${system};

      # Static binary; keeps behaviour consistent with the other Go CLIs
      # in this repo and avoids linking against the host libc.
      env.CGO_ENABLED = 0;

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
