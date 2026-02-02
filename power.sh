#!/bin/bash

BATTERY_PATH="/org/freedesktop/UPower/devices/battery_BAT0"

# 获取电池状态（Charging/Discharging/Full/Unknown）
STATE=$(upower -i "$BATTERY_PATH" | grep -E "state:" | awk '{print $2}')

# 获取电池电量百分比
PERCENTAGE=$(upower -i "$BATTERY_PATH" | grep -E "percentage:" | awk '{print $2}' | sed 's/%//')

# 获取剩余时间（放电时显示剩余使用时间，充电时显示充满时间）
if [ "$STATE" = "discharging" ]; then
    TIME=$(upower -i "$BATTERY_PATH" | grep -E "time to empty" | awk -F': ' '{print $2}')
elif [ "$STATE" = "charging" ]; then
    TIME=$(upower -i "$BATTERY_PATH" | grep -E "time to full" | awk -F': ' '{print $2}')
else
    TIME="--"  # 满电或未知状态时显示
fi

# 配置电池图标（根据电量和状态选择）
if [ "$STATE" = "charging" ]; then
    ICON=""  # 充电图标（Nerd Font 必需）
elif [ "$PERCENTAGE" -ge 90 ]; then
    ICON=""  # 满电图标
elif [ "$PERCENTAGE" -ge 60 ]; then
    ICON=""  # 3/4 电量图标
elif [ "$PERCENTAGE" -ge 30 ]; then
    ICON=""  # 1/2 电量图标
elif [ "$PERCENTAGE" -ge 10 ]; then
    ICON=""  # 1/4 电量图标
else
    ICON=""  # 低电量图标（警告）
fi

# 输出 Waybar 格式的 JSON 数据（包含图标、电量、时间、状态）
echo "$ICON $PERCENTAGE%"
