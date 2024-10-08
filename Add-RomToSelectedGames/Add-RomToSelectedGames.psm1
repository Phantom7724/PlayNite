# 添加ROM到游戏详情
function Add-RomToSelectedGames {
    param($menuItemActionArgs)  # 添加参数以接受 ScriptMainMenuItemActionArgs

    $changedCount = 0

    foreach ($game in $PlayniteApi.MainView.SelectedGames) {

        if ($game -eq $null -or [string]::IsNullOrEmpty($game.InstallDirectory)) {
            continue
        }

        # 假设要使用第一个 GameAction 的路径
        $romPath = $null
        if ($game.GameActions -ne $null -and $game.GameActions.Count -gt 0) {
            # 获取第一个 GameAction 的路径作为 ROM 路径
            $firstAction = $game.GameActions[0]
            $romPath = $firstAction.Path
        }

        if ([string]::IsNullOrEmpty($romPath)) {
            # 如果 GameAction 中没有路径，使用游戏的 InstallDirectory
            $romPath = $game.InstallDirectory
        }

        # 添加 ROM
        $rom = New-Object Playnite.SDK.Models.GameRom
        $rom.Name = $game.Name
        $rom.Path = $romPath

        if ($game.Roms -eq $null) {
            $game.Roms = @()
        }

        $game.Roms.Add($rom)
        $PlayniteApi.Database.Games.Update($game)
        $changedCount++
    }

    # 使用 Playnite 对话框显示结果
    $PlayniteApi.Dialogs.ShowMessage("已为 $changedCount 个游戏添加ROM信息")
}

# 添加主菜单项目
function GetMainMenuItems {
    param($getMainMenuItemsArgs)

    # 创建菜单项
    $menuItems = @()

    $romMenuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $romMenuItem.Description = "选择游戏 添加ROM信息"
    $romMenuItem.FunctionName = "Add-RomToSelectedGames"
    $menuItems += $romMenuItem

    return $menuItems
}

# 添加右键菜单项目
function GetGameMenuItems {
    param($getGameMenuItemsArgs)

    # 创建菜单项
    $GamemenuItems = @()

    $romGameMenuItem = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
    $romGameMenuItem.Description = "添加ROM信息"
    $romGameMenuItem.FunctionName = "Add-RomToSelectedGames"
    $GamemenuItems += $romGameMenuItem

    return $GamemenuItems
}
# 导出函数
Export-ModuleMember -Function Connect-PlayniteSession, Add-RomToSelectedGames, Add-ActionToSelectedGames, GetMainMenuItems, GetGameMenuItems
