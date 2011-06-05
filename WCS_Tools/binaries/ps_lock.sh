echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo WAKE_LOCK_SUSPEND > /sys/power/wake_lock
echo 0 > /sys/kernel/debug/pm_debug/sleep_while_idle