#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f frontend/package.json ]]; then
  echo "Vue app already exists: frontend/"
  exit 0
fi

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

run() {
  if command -v mise >/dev/null 2>&1; then
    mise exec -- "$@"
  else
    "$@"
  fi
}

run npm create vite@latest frontend -- --template vue
run npm install --prefix "$ROOT_DIR/frontend"

cat > "$ROOT_DIR/frontend/src/App.vue" <<'VUE'
<script setup>
const title = 'Привет, мир'
</script>

<template>
  <main style="font-family: sans-serif; padding: 2rem;">
    <h1>{{ title }}</h1>
    <p>Vue 3 + Vite hot reload is enabled.</p>
  </main>
</template>
VUE

cat > "$ROOT_DIR/frontend/src/main.js" <<'JS'
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#vue-app')
JS

echo "Vue app initialized (native)"
