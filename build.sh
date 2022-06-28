NAME=app
DIST_DIR=build

if [ -e build/$NAME ]; then
  echo build/$NAME already exists. Please remove it and try again.
  exit 1
fi

python -m nuitka \
        --follow-imports \
        --onefile \
        --windows-icon-from-ico=$NAME/resource/icon/app.ico \
        --plugin-enable=pyside6 \
        --include-qt-plugins=platforms,qml,imageformats,tls \
        --include-data-file=$NAME/*.json=./$NAME/ \
        --include-data-file=$NAME/.env=./$NAME/ \
        --include-data-file=$NAME/apple.png=./$NAME/ \
        --include-data-dir=$NAME/qml=./$NAME/qml \
        --include-data-dir=$NAME/backend=./$NAME/backend \
        --include-module=dotenv \
        --output-dir=build/$NAME \
        run.py

