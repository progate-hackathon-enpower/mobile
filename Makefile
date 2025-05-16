.PHONY: web vercel_build

vercel_build:
		flutter/bin/flutter build web --release --dart-define=SUPABASE_URL=${SUPABASE_URL} --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY} --dart-define=GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} --dart-define=GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID}