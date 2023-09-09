require "language/node"

class OpensearchDashboards < Formula
  desc "Open source visualization dashboards for OpenSearch"
  homepage "https://opensearch.org/docs/dashboards/index/"
  url "https://github.com/opensearch-project/OpenSearch-Dashboards.git",
      tag:      "2.9.0",
      revision: "1f82eda3935dc5b648cb31587662c84cb43f3801"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "e9253c3bd182860c2b05e743a5defed8cf495e9ded59ca0a1d10be84e1b336cf"
    sha256 cellar: :any_skip_relocation, monterey:     "ebbc42e505b435503ea8ca8e84ad58ab5fd95150d0aab67a33fe9230d13e4cfb"
    sha256 cellar: :any_skip_relocation, big_sur:      "ebbc42e505b435503ea8ca8e84ad58ab5fd95150d0aab67a33fe9230d13e4cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0964149b822339ee6fd07743db63a9c9fced4ed1143ef5f111da67b64598e623"
  end

  # Match deprecation date of `node@18`.
  deprecate! date: "2023-10-18", because: "uses deprecated `node@18`"

  depends_on "yarn" => :build
  depends_on "node@18"

  # Do not download node and discard all actions related to this node
  patch :DATA

  def install
    system "yarn", "osd", "bootstrap"
    system "node", "scripts/build", "--release", "--skip-os-packages", "--skip-archives", "--skip-node-download"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    cd "build/opensearch-dashboards-#{version}-#{os}-#{arch}" do
      inreplace "bin/use_node",
                /NODE=".+"/,
                "NODE=\"#{Formula["node@18"].opt_bin/"node"}\""

      inreplace "config/opensearch_dashboards.yml",
                /#\s*pid\.file: .+$/,
                "pid.file: #{var}/run/opensearchDashboards.pid"

      (etc/"opensearch-dashboards").install Dir["config/*"]
      rm_rf Dir["{config,data,plugins}"]

      prefix.install Dir["*"]
    end
  end

  def post_install
    (var/"log/opensearch-dashboards").mkpath

    (var/"lib/opensearch-dashboards").mkpath
    ln_s var/"lib/opensearch-dashboards", prefix/"data" unless (prefix/"data").exist?

    (var/"opensearch-dashboards/plugins").mkpath
    ln_s var/"opensearch-dashboards/plugins", prefix/"plugins" unless (prefix/"plugins").exist?

    ln_s etc/"opensearch-dashboards", prefix/"config" unless (prefix/"config").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch-dashboards/
      Logs:    #{var}/log/opensearch-dashboards/opensearch-dashboards.log
      Plugins: #{var}/opensearch-dashboards/plugins/
      Config:  #{etc}/opensearch-dashboards/
    EOS
  end

  service do
    run opt_bin/"opensearch-dashboards"
    log_path var/"log/opensearch-dashboards.log"
    error_log_path var/"log/opensearch-dashboards.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"

    (testpath/"data").mkdir
    (testpath/"config.yml").write <<~EOS
      path.data: #{testpath}/data
    EOS

    port = free_port
    fork do
      exec bin/"opensearch-dashboards", "-p", port.to_s, "-c", testpath/"config.yml"
    end
    sleep 15
    output = shell_output("curl -s 127.0.0.1:#{port}")
    # opensearch-dashboards returns this message until it connects to opensearch
    assert_equal "OpenSearch Dashboards server is not ready yet", output
  end
end

__END__
diff --git a/src/dev/build/args.ts b/src/dev/build/args.ts
index 7e131174e3..71745e5305 100644
--- a/src/dev/build/args.ts
+++ b/src/dev/build/args.ts
@@ -133,6 +133,7 @@ export function readCliArgs(argv: string[]) {
     targetPlatforms: {
       windows: Boolean(flags.windows),
       darwin: Boolean(flags.darwin),
+      darwinArm: Boolean(flags['darwin-arm']),
       linux: Boolean(flags.linux),
       linuxArm: Boolean(flags['linux-arm']),
     },
diff --git a/src/dev/build/build_distributables.ts b/src/dev/build/build_distributables.ts
index d764c5df28..e37b71e04a 100644
--- a/src/dev/build/build_distributables.ts
+++ b/src/dev/build/build_distributables.ts
@@ -63,8 +63,6 @@ export async function buildDistributables(log: ToolingLog, options: BuildOptions
    */
   await run(Tasks.VerifyEnv);
   await run(Tasks.Clean);
-  await run(options.downloadFreshNode ? Tasks.DownloadNodeBuilds : Tasks.VerifyExistingNodeBuilds);
-  await run(Tasks.ExtractNodeBuilds);

   /**
    * run platform-generic build tasks
diff --git a/src/dev/build/lib/config.ts b/src/dev/build/lib/config.ts
index 6af5b8e690..1296eb65e4 100644
--- a/src/dev/build/lib/config.ts
+++ b/src/dev/build/lib/config.ts
@@ -155,6 +155,7 @@ export class Config {

     const platforms: Platform[] = [];
     if (this.targetPlatforms.darwin) platforms.push(this.getPlatform('darwin', 'x64'));
+    if (this.targetPlatforms.darwinArm) platforms.push(this.getPlatform('darwin', 'arm64'));
     if (this.targetPlatforms.linux) platforms.push(this.getPlatform('linux', 'x64'));
     if (this.targetPlatforms.windows) platforms.push(this.getPlatform('win32', 'x64'));
     if (this.targetPlatforms.linuxArm) platforms.push(this.getPlatform('linux', 'arm64'));
diff --git a/src/dev/build/lib/platform.ts b/src/dev/build/lib/platform.ts
index 673356ec62..f83107f737 100644
--- a/src/dev/build/lib/platform.ts
+++ b/src/dev/build/lib/platform.ts
@@ -33,6 +33,7 @@ export type PlatformArchitecture = 'x64' | 'arm64';

 export interface TargetPlatforms {
   darwin: boolean;
+  darwinArm: boolean;
   linuxArm: boolean;
   linux: boolean;
   windows: boolean;
@@ -78,5 +79,6 @@ export const ALL_PLATFORMS = [
   new Platform('linux', 'x64', 'linux-x64'),
   new Platform('linux', 'arm64', 'linux-arm64'),
   new Platform('darwin', 'x64', 'darwin-x64'),
+  new Platform('darwin', 'arm64', 'darwin-arm64'),
   new Platform('win32', 'x64', 'windows-x64'),
 ];
diff --git a/src/dev/build/tasks/create_archives_sources_task.ts b/src/dev/build/tasks/create_archives_sources_task.ts
index 55d9b5313f..b4ecbb0d3d 100644
--- a/src/dev/build/tasks/create_archives_sources_task.ts
+++ b/src/dev/build/tasks/create_archives_sources_task.ts
@@ -41,34 +41,6 @@ export const CreateArchivesSources: Task = {
           source: build.resolvePath(),
           destination: build.resolvePathForPlatform(platform),
         });
-
-        log.debug(
-          'Generic build source copied into',
-          platform.getNodeArch(),
-          'specific build directory'
-        );
-
-        // copy node.js install
-        await scanCopy({
-          source: (await getNodeDownloadInfo(config, platform)).extractDir,
-          destination: build.resolvePathForPlatform(platform, 'node'),
-        });
-
-        // ToDo [NODE14]: Remove this Node.js 14 fallback download
-        // Copy the Node.js 14 binaries into node/fallback to be used by `use_node`
-        await scanCopy({
-          source: (
-            await getNodeVersionDownloadInfo(
-              NODE14_FALLBACK_VERSION,
-              platform.getNodeArch(),
-              platform.isWindows(),
-              config.resolveFromRepo()
-            )
-          ).extractDir,
-          destination: build.resolvePathForPlatform(platform, 'node', 'fallback'),
-        });
-
-        log.debug('Node.js copied into', platform.getNodeArch(), 'specific build directory');
       })
     );
   },
diff --git a/src/dev/notice/generate_build_notice_text.js b/src/dev/notice/generate_build_notice_text.js
index b32e200915..2aab53f3ea 100644
--- a/src/dev/notice/generate_build_notice_text.js
+++ b/src/dev/notice/generate_build_notice_text.js
@@ -48,7 +48,7 @@ export async function generateBuildNoticeText(options = {}) {

   const packageNotices = await Promise.all(packages.map(generatePackageNoticeText));

-  return [noticeFromSource, ...packageNotices, generateNodeNoticeText(nodeDir, nodeVersion)].join(
+  return [noticeFromSource, ...packageNotices, ''].join(
     '\n---\n'
   );
 }
