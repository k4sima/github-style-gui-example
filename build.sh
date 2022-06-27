NAME=app
DIST_DIR=build

if [ -e build/$NAME ]; then
  echo build/$NAME already exists. Please remove it and try again.
  exit 1
fi

python -m nuitka \
        --mingw64 \
        --follow-imports \
        --onefile \
        --windows-icon-from-ico=$NAME/resource/icon/waraiotoko.ico \
        --plugin-enable=pyside6 \
        --include-qt-plugins=platforms,qml,imageformats \
        --include-data-file=$NAME/*.json=./$NAME/ \
        --include-data-file=$NAME/.env=./$NAME/ \
        --include-data-dir=$NAME/qml=./$NAME/qml \
        --output-dir=build/$NAME \
        run.py

