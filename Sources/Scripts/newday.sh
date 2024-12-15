#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: ./newday.sh DAY_NUMBER"
    exit 1
fi

DAY=$(printf "%02d" $1)
TARGET="Sources/Solutions/Day$DAY.swift"
if [ -f "$TARGET" ]; then
    echo "Day $DAY already exists."
    exit 1
fi

cp Sources/Utils/DayTemplate.swift "$TARGET"
sed -i '' "s/DayXX/Day$DAY/g" "$TARGET"
sed -i '' "s/dayXX/day$DAY/g" "$TARGET"

echo "Created $TARGET"