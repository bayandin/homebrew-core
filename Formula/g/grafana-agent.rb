class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "d5725005f2b5ef99cf9a986254fdcdb308b0497f69373090cff2f04557a5fa2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a830f71a9a00b84b13e5d61cf8972028fad414a396240f5342c4a2fabebdb73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1cf458aa4b57fbe2f36e25ede7a14f5da4abfeea2fff30ad3b142d35086744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "905e18e65498ba5e4e9c87e6348c6101ac50812c3e95016a388f9b894ef55651"
    sha256 cellar: :any_skip_relocation, ventura:        "fc31722cb368461f812c1db1a063067b91dd87c544fc21cae2902c3a95b541c7"
    sha256 cellar: :any_skip_relocation, monterey:       "99289aa4dcc95595e3b0a54aefc0975fe01a756ff5087719ca38ddb0647427ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c6634b329d01b5d6baf133c3ec8fc4596e036ec01df6f39bca0ef4a91d22a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59197f41f946a6d3a9588f32182aad821b702317180fc6674e5594a4628d47d7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  # go 1.21.0 build patch, https://github.com/grafana/agent/pull/4946
  # remove in next release
  patch :DATA

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "web/ui" do
      system "yarn"
      system "yarn", "run", "build"
    end

    system "go", "build", *args, "./cmd/grafana-agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/grafana-agentctl"
  end

  def post_install
    (etc/"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-agent/config.yml
    EOS
  end

  service do
    run [opt_bin/"grafana-agent", "-config.file", etc/"grafana-agent/config.yml"]
    keep_alive true
    log_path var/"log/grafana-agent.log"
    error_log_path var/"log/grafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}/grafana-agentctl --version")

    port = free_port

    (testpath/"wal").mkpath

    (testpath/"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
    EOS

    system bin/"grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}/wal", "-server.http.address=127.0.0.1:#{port}",
        "-server.grpc.address=127.0.0.1:#{free_port}"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end

__END__
diff --git a/go.mod b/go.mod
index 2d8d826..e8048d4 100644
--- a/go.mod
+++ b/go.mod
@@ -149,7 +149,7 @@ require (
 	github.com/prometheus/prometheus v1.99.0
 	github.com/prometheus/snmp_exporter v0.22.1-0.20230623130038-562ae9055ce3
 	github.com/prometheus/statsd_exporter v0.22.8
-	github.com/pyroscope-io/godeltaprof v0.1.1
+	github.com/pyroscope-io/godeltaprof v0.1.2
 	github.com/richardartoul/molecule v1.0.1-0.20221107223329-32cfee06a052
 	github.com/rs/cors v1.9.0
 	github.com/shirou/gopsutil/v3 v3.23.5
diff --git a/go.sum b/go.sum
index 0a16dee..a8a4c27 100644
--- a/go.sum
+++ b/go.sum
@@ -3047,8 +3047,8 @@ github.com/prometheus/statsd_exporter v0.22.7/go.mod h1:N/TevpjkIh9ccs6nuzY3jQn9
 github.com/prometheus/statsd_exporter v0.22.8 h1:Qo2D9ZzaQG+id9i5NYNGmbf1aa/KxKbB9aKfMS+Yib0=
 github.com/prometheus/statsd_exporter v0.22.8/go.mod h1:/DzwbTEaFTE0Ojz5PqcSk6+PFHOPWGxdXVr6yC8eFOM=
 github.com/prometheus/tsdb v0.7.1/go.mod h1:qhTCs0VvXwvX/y3TZrWD7rabWM+ijKTux40TwIPHuXU=
-github.com/pyroscope-io/godeltaprof v0.1.1 h1:+Mmi+b9gR3s/qufuQSxOBjyXZR1fmvS/C12Q73PIPvw=
-github.com/pyroscope-io/godeltaprof v0.1.1/go.mod h1:psMITXp90+8pFenXkKIpNhrfmI9saQnPbba27VIaiQE=
+github.com/pyroscope-io/godeltaprof v0.1.2 h1:MdlEmYELd5w+lvIzmZvXGNMVzW2Qc9jDMuJaPOR75g4=
+github.com/pyroscope-io/godeltaprof v0.1.2/go.mod h1:psMITXp90+8pFenXkKIpNhrfmI9saQnPbba27VIaiQE=
 github.com/rcrowley/go-metrics v0.0.0-20181016184325-3113b8401b8a/go.mod h1:bCqnVzQkZxMG4s8nGwiZ5l3QUCyqpo9Y+/ZMZ9VjZe4=
 github.com/rcrowley/go-metrics v0.0.0-20200313005456-10cdbea86bc0/go.mod h1:bCqnVzQkZxMG4s8nGwiZ5l3QUCyqpo9Y+/ZMZ9VjZe4=
 github.com/rcrowley/go-metrics v0.0.0-20201227073835-cf1acfcdf475 h1:N/ElC8H3+5XpJzTSTfLsJV/mx9Q9g7kxmchpfZyxgzM=
