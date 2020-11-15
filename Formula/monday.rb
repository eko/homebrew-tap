class Monday < Formula
  desc "A dev tool for microservice developers to run local applications and/or forward others from/to Kubernetes SSH or TCP"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday.git",
      :tag      => "v2.1.0",
      :revision => "bf2ff571660e0a3f83a9c7e3526c7379408f41af"
  head "https://github.com/eko/monday.git"

  bottle do
    root_url "https://github.com/eko/monday/releases/download/v2.1.0/"
    cellar :any_skip_relocation
    sha256 "47fe6bee6894c764d8d634fc6b6eda836711800ad7f89751cd5d4890d84068ea" => :big_sur
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
