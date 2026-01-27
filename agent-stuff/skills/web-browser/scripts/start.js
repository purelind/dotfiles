#!/usr/bin/env node

import { spawn, execSync } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const useProfile = process.argv[2] === "--profile";
const forceRestart = process.argv[2] === "--force" || process.argv[3] === "--force";

if (process.argv[2] && !["--profile", "--force"].includes(process.argv[2])) {
  console.log("Usage: start.js [--profile] [--force]");
  console.log("\nOptions:");
  console.log("  --profile  Copy your default Chrome profile (cookies, logins)");
  console.log("  --force    Kill existing Chrome and restart (WARNING: closes all Chrome windows)");
  console.log("\nExamples:");
  console.log("  start.js            # Start test Chrome alongside your normal Chrome");
  console.log("  start.js --profile  # Start with copy of your Chrome profile");
  console.log("  start.js --force    # Force restart (kills existing Chrome)");
  process.exit(1);
}

// Check if port 9222 is already available (debugging Chrome already running)
async function checkExistingDebugger() {
  try {
    const response = await fetch("http://localhost:9222/json/version");
    if (response.ok) {
      return true;
    }
  } catch {
    return false;
  }
  return false;
}

// Check if we can reuse existing debugging Chrome
const existingDebugger = await checkExistingDebugger();
if (existingDebugger && !forceRestart) {
  console.log("✓ Chrome debugger already running on :9222");
  console.log("  (use --force to restart)");
  process.exit(0);
}

// Only kill Chrome if --force is explicitly specified
if (forceRestart) {
  console.log("⚠ Force mode: killing existing Chrome...");
  try {
    execSync("killall 'Google Chrome'", { stdio: "ignore" });
  } catch {}
  await new Promise((r) => setTimeout(r, 1000));
}

// Setup profile directory (separate from normal Chrome profile)
const profileDir = `${process.env["HOME"]}/.cache/chrome-automation`;
execSync(`mkdir -p "${profileDir}"`, { stdio: "ignore" });

if (useProfile) {
  console.log("Syncing profile (this may take a moment)...");
  // Sync profile with rsync (much faster on subsequent runs)
  execSync(
    `rsync -a --delete "${process.env["HOME"]}/Library/Application Support/Google/Chrome/" "${profileDir}/"`,
    { stdio: "pipe" },
  );
}

// Start Chrome in background with separate user data directory
// This allows running alongside normal Chrome
spawn(
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  [
    "--remote-debugging-port=9222",
    `--user-data-dir=${profileDir}`,
    "--profile-directory=Default",
    "--disable-search-engine-choice-screen",
    "--no-first-run",
    "--disable-features=ProfilePicker",
    "--new-window",
  ],
  { detached: true, stdio: "ignore" },
).unref();

// Wait for Chrome to be ready by checking the debugging endpoint
let connected = false;
for (let i = 0; i < 30; i++) {
  try {
    const response = await fetch("http://localhost:9222/json/version");
    if (response.ok) {
      connected = true;
      break;
    }
  } catch {
    await new Promise((r) => setTimeout(r, 500));
  }
}

if (!connected) {
  console.error("✗ Failed to connect to Chrome on :9222");
  console.error("  If your normal Chrome is using port 9222, try: --force");
  process.exit(1);
}

// Start background watcher for logs/network (detached)
const scriptDir = dirname(fileURLToPath(import.meta.url));
const watcherPath = join(scriptDir, "watch.js");
spawn(process.execPath, [watcherPath], { detached: true, stdio: "ignore" }).unref();

console.log(`✓ Test Chrome started on :9222${useProfile ? " with your profile" : ""}`);
console.log("  Your normal Chrome windows are unaffected.");
console.log("  Profile location: ~/.cache/chrome-automation");
