# Alias `adb`
New-Alias -Name adb -Value "$Env:UserProfile\AppData\Local\Android\Sdk\platform-tools\adb.exe"

function adba {
    param (
        $Value
    )

    adb shell settings put global window_animation_scale $Value
    adb shell settings put global transition_animation_scale $Value
    adb shell settings put global animator_duration_scale $Value
}

# Alias `su` to launch new powershell with admin priveleges
function su { Start-Process wt -Verb runAs }

# Alias to launch clear wsl cache and free up RAM
function mem { wsl -u root bash -c "echo 1 > /proc/sys/vm/drop_caches" }