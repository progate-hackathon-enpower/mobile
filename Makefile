.PHONY: web vercel_build
# .envファイルを読み込んで dart-define の形式に変換
ENV_VARS := $(shell cat .env | sed 's/^/--dart-define=/')

# Flutter Web を Chrome で起動
web:
    flutter run -d chrome $(ENV_VARS)

vercel_build:
		\flutter/bin/flutter build web --release --web-renderer html --dart-define=SUPABASE_URL=${SUPABASE_URL} --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} --dart-define=GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} --dart-define=GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID}