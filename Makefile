.PHONY: web
# .envファイルを読み込んで dart-define の形式に変換
ENV_VARS := $(shell cat .env | sed 's/^/--dart-define=/')

# Flutter Web を Chrome で起動
web:
    flutter run -d chrome $(ENV_VARS)