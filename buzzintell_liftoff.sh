#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "🚀 BUZZINTELL LIFTOFF — ENGINE IGNITION"
echo "Timestamp: $(date -Iseconds)"
echo "--------------------------------------"

### 1. Repos & Base Integrity
pkg update && pkg upgrade -y
pkg install -y termux-tools
termux-change-repo <<EOF
1
2
3
0
EOF
pkg update

### 2. Canonical Toolchain (Deep-Matter Baseline)
pkg install -y \
  clang \
  lld \
  rust \
  cmake \
  make \
  pkg-config \
  libffi \
  openssl \
  openjdk-17-jdk \
  android-tools \
  python \
  python-pip \
  git \
  curl \
  unzip

### 3. BuzzIntell Modular Skeleton
BASE="$HOME/BuzzIntell"
mkdir -p "$BASE"/{core,modules,flows,artifacts,logs,env}

### 4. Environment Fingerprint (Success Evidence)
cat > "$BASE/env/fingerprint.env" <<EOF
TERMUX_INFO=$(termux-info | head -n 1)
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
PYTHON_VERSION=$(python --version)
RUST_VERSION=$(rustc --version)
CLANG_VERSION=$(clang --version | head -n 1)
DATE=$(date -Iseconds)
EOF

### 5. Python Deep-Matter Safe Install
pip install --upgrade pip setuptools wheel
pip install cryptography --no-build-isolation
pip install androguard

python - <<'EOF'
import cryptography, androguard
print("✔ Python layer compliant")
EOF

### 6. BuzzStripFlow Integration (if present)
if [ -d "$HOME/BuzzStripFlow" ]; then
  mv "$HOME/BuzzStripFlow" "$BASE/flows/BuzzStripFlow"
fi

### 7. APK Alignment & Signing (if APK exists)
APK_IN="$BASE/flows/BuzzStripFlow/output/final.apk"
APK_OUT="$BASE/artifacts/final-aligned.apk"

if [ -f "$APK_IN" ]; then
  zipalign -p 4 "$APK_IN" "$APK_OUT"

  if [ ! -f "$BASE/core/buzz.keystore" ]; then
    keytool -genkeypair \
      -keystore "$BASE/core/buzz.keystore" \
      -alias buzzkey \
      -keyalg RSA \
      -keysize 2048 \
      -validity 10000 \
      -dname "CN=BuzzIntell,O=Buzz,L=DeepMatter,ST=Aligned,C=US"
  fi

  apksigner sign \
    --ks "$BASE/core/buzz.keystore" \
    --ks-key-alias buzzkey \
    "$APK_OUT"

  apksigner verify "$APK_OUT"
  echo "✔ APK aligned, signed, verified"
else
  echo "ℹ No APK found — engine standing by"
fi

### 8. Final State Assertion
echo "--------------------------------------"
echo "🔥 BUZZINTELL ENGINE STATUS: LIFTED"
echo "Artifacts: $BASE/artifacts"
echo "Fingerprint: $BASE/env/fingerprint.env"
echo "Modules online. Success is attributable."
echo "--------------------------------------"
