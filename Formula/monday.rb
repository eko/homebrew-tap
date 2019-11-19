class Monday < Formula
  desc "A dev tool for microservice developers to run local applications and/or forward others from/to Kubernetes SSH or TCP"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday.git",
      :tag      => "v1.0.7",
      :revision => "f42ef002bec2bd02c53d564857a22dba6ff3bbb4"
  head "https://github.com/eko/monday.git"

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
