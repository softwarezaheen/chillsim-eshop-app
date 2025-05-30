#!/bin/bash
# Script to update Android notification icons for different environments
# This script uses the same configuration files as generate_env.sh
# Usage: ./update_notification_icons.sh <environment>

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Source notification icon path
SOURCE_ICON="assets/images/open_source/logo/notificationIcon.png"

# Verify source icon exists
if [ ! -f "$SOURCE_ICON" ]; then
  echo -e "${RED}Error: Source notification icon not found: $SOURCE_ICON${NC}"
  exit 1
fi

# Target Android resource directories
ICON_PATHS=(
  "android/app/src/main/res/drawable-mdpi/ic_notification.png"
  "android/app/src/main/res/drawable-hdpi/ic_notification.png"
  "android/app/src/main/res/drawable-xhdpi/ic_notification.png"
  "android/app/src/main/res/drawable-xxhdpi/ic_notification.png"
  "android/app/src/main/res/drawable-xxxhdpi/ic_notification.png"
)

# Create directories if they don't exist
for icon_path in "${ICON_PATHS[@]}"; do
  dir_path=$(dirname "$icon_path")
  mkdir -p "$dir_path"
done

# Copy source icon to all target paths
echo -e "${YELLOW}Copying notification icon from ${SOURCE_ICON}${NC}"

for icon_path in "${ICON_PATHS[@]}"; do
  cp "$SOURCE_ICON" "$icon_path"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully copied to: $icon_path${NC}"
  else
    echo -e "${RED}Failed to copy to: $icon_path${NC}"
    exit 1
  fi
done

echo -e "${GREEN}Notification icons updated successfully for $ENV environment!${NC}"
