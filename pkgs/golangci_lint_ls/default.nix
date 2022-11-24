{ stdenv, buildGoModule, fetchFromGitHub, lib, golangci-lint }:

buildGoModule rec {
  pname = "golangci_lint_ls";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint-langserver ";
    rev = "v${version}";
    sha256 = "sha256-7sDAwWz+qoB/ngeH35tsJ5FZUfAQvQsU6kU9rUHIHMk=";
  };

  vendorSha256 = "sha256-w38OKN6HPoz37utG/2QSPMai55IRDXCIIymeMe6ogIU=";

  doCheck = true;
  # doCheck = false;

  # subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ golangci-lint ];

  ldflags = [
    # "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" "-X main.date=19700101-00:00:00"
    "-s" "-w" "-X main.version=${version}"
  ];

  postInstall = ''
    # for shell in bash zsh fish; do
    #   HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
    #   installShellCompletion golangci-lint.$shell
    # done
  '';

  meta = with lib; {
    description = "golangci-lint language server";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = licenses.mit;
    maintainers = with maintainers; [
      {
       email = "nametake.kyarabuki@gmail.com";
       github = "nametake";
       githubId = 4082108;
       name = "Shogo NAMEKI";
     }
    ];
    # broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
