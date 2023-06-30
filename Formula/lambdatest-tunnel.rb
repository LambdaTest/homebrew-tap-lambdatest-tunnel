require "net/http"
require "json"

class TunnelConfig
  def initialize
    uri = URI("https://ts.lambdatest.com/v1.0/tunnel/config")
    response = Net::HTTP.get_response(uri)
    @data = JSON.parse(response.body)
  end

  def sha256
    @data["config"]["mac_client_hash"].to_s
  end

  def version
    @data["config"]["client_version"].to_s
  end
end

class LambdatestTunnel < Formula
  # Creating object of tunnel config class
  config = TunnelConfig.new
  ver = config.version
  desc "Package for LambdaTest Tunnel"
  homepage "https://automation.lambdatest.com"
  url "https://downloads.lambdatest.com/tunnel/v3/mac/64bit/LT_Mac.zip"
  version ver.empty? ? "3.1.3" : ver
  sha256 config.sha256
  license "Apache-2.0"

  def install
    system "curl", "-L", "-o", "Lt_mac", "https://downloads.lambdatest.com/tunnel/v3/mac/64bit/LT_Mac.zip"
    # Unzipping binary
    system "unzip", "Lt_mac", "-d", bin.to_s
    mv "#{bin}/LT", "#{bin}/lambdatest-tunnel"

    # Making binary executable
    chmod "+x", "#{bin}/lambdatest-tunnel"

    # Installation success message
    puts "LambdaTest Tunnel is installed!"
    puts "To run the tunnel, use the following command:"
    puts "lambdatest-tunnel --user <name> -key <accesskey>"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lambdatest-tunnel --version")
  end
end
