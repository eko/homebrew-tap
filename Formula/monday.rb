class Monday < Formula
  desc "A dev tool for microservice developers to run local applications and/or forward others from/to Kubernetes SSH or TCP"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday.git",
      :tag      => "v1.0.10",
      :revision => "904ea13f32a620146b15d01a15790edfce3c1f3c"
  head "https://github.com/eko/monday.git"

  bottle do
    root_url "https://github.com/eko/monday/releases/download/v1.0.10"
    cellar :any_skip_relocation
    sha256 "82b5d1226f77ccb32f308688a8ac370063af1dba32d79d1725d117734f7c0d0c" => :catalina
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
