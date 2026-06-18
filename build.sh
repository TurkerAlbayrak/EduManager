#!/bin/bash
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git
fi
export PATH="$PATH:$PWD/flutter/bin"
echo "SUPABASE_URL=$SUPABASE_URL" > .env
echo "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" >> .env
echo "REGISTER_TOKEN=$REGISTER_TOKEN" >> .env
flutter build web
