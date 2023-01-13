# This script creates/updates credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${DART_PUBLISH_ACCESS_TOKEN}" ]; then
  echo "Missing DART_PUBLISH_ACCESS_TOKEN environment variable"
  exit 1
fi

if [ -z "${DART_PUBLISH_REFRESH_TOKEN}" ]; then
  echo "Missing DART_PUBLISH_REFRESH_TOKEN environment variable"
  exit 1
fi

# Create credentials.json file.
cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"${DART_PUBLISH_ACCESS_TOKEN}",
  "refreshToken":"${DART_PUBLISH_REFRESH_TOKEN}",
  "scopes":["https://www.googleapis.com/auth/userinfo.email","openid"],
}
EOF
