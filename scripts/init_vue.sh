#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f frontend/package.json ]]; then
  echo "Vue app already exists: frontend/"
  exit 0
fi

docker run --rm -v "$ROOT_DIR:/app" -w /app node:22 bash -lc "npm create vite@latest frontend -- --template vue"
docker run --rm -v "$ROOT_DIR/frontend:/app/frontend" -w /app/frontend node:22 bash -lc "npm install"

cat > frontend/src/App.vue <<'VUE'
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

cat > frontend/src/main.js <<'JS'
import { createApp } from 'vue'
import App from './App.vue'

createApp(App).mount('#vue-app')
JS

echo "Vue app initialized"
