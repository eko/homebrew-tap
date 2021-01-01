class Monday < Formula
  desc "A dev tool for microservice developers to run local applications and/or forward others from/to Kubernetes SSH or TCP"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday.git",
      :tag      => "v2.1.1",
      :revision => "0959864fee487832115f25f132a70bfe6509b4d6"
  head "https://github.com/eko/monday.git"

  bottle do
    root_url "https://github.com/eko/monday/releases/download/v2.1.1/"
    cellar :any_skip_relocation
    sha256 "35898aafa42f5709ef3f2986c86a53a968e3416ec57c5975abe2a73fc6bf263e" => :big_sur
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/eko/monday"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make build-binary"
      bin.install "monday"

      output = Utils.popen_read("#{bin}/monday completion bash")
      (bash_completion/"monday").write output

      output = Utils.popen_read("#{bin}/monday completion zsh")
      (zsh_completion/"_monday").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/monday version")
    assert_match "Monday - version", output
  end
end
