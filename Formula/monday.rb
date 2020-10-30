class Monday < Formula
  desc "A dev tool for microservice developers to run local applications and/or forward others from/to Kubernetes SSH or TCP"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday.git",
      :tag      => "v2.0.0",
      :revision => "deefeca0ee24172e4253aa5cd0356a361e7f48b2"
  head "https://github.com/eko/monday.git"

  bottle do
    root_url "https://github.com/eko/monday/releases/download/v2.0.0"
    cellar :any_skip_relocation
    sha256 "f035a45ab652b384779ddac4bf9c70d2479c8e0fef3620be881380081bf7e218" => :catalina
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
