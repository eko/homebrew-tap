# typed: true
# frozen_string_literal: true

# This file was generated by Homebrew Releaser. DO NOT EDIT.
class Monday < Formula
  desc "⚡️ a dev tool for microservice developers to run local applications and/or forwa"
  homepage "https://github.com/eko/monday"
  url "https://github.com/eko/monday/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "edc355a876845799f10fc39d3c43022a4042109f947d5e82fca0e2bcb3fe7102"
  license "MIT"

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
    assert_match("Monday - version", shell_output("#{bin}/monday version"))
  end
end
