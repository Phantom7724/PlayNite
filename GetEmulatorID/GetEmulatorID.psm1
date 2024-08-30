# PlayniteExtension.psm1

# 定义获取模拟器信息并写入文件的函数
function Write-EmulatorInfoToFileFromMenu {
    param ($args)
    
    # 获取 Playnite API 的 EmulatorDefinition 类
    $emulators = $PlayniteApi.Database.Emulators
    
    # 创建一个路径来保存信息文件
    $filePath = "EmulatorInfo.txt"
    
    # 清除现有文件内容
    if (Test-Path $filePath) {
        Clear-Content $filePath
    }

    # 将每个模拟器的信息写入文件
    foreach ($emulator in $emulators) {
        $id = $emulator.ID
        $name = $emulator.Name
        $profiles = $emulator.AllProfiles

        # 构建配置文件信息
        $profilesInfo = $profiles | ForEach-Object {
            "Profile ID: $($_.Id), Name: $($_.Name)"
        }

        $infoLine = "Name: $name`nID: $id`n$profilesInfo`n"
        Add-Content -Path $filePath -Value $infoLine
    }
}

# 添加主菜单项目
function GetMainMenuItems {
    param($getMainMenuItemsArgs)
    
    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "输出模拟器信息"
    $menuItem.FunctionName = "Write-EmulatorInfoToFileFromMenu"  # 当点击菜单时，调用的函数
    return $menuItem
}
