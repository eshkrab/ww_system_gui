#!/bin/bash

# Run Flutter build
flutter build web

# Navigate to the build directory
cd build/web

# Create config.js
echo "window._env_ = {
  SERVER_IP: 'litpi.local',
  SERVER_PORT: '8000'
}" > config.js

# Insert script tag into index.html
sed -i '' -e '/<body>/a\
\
    <!-- Load environment variables -->\
    <script src="config.js"></script>
' index.html
