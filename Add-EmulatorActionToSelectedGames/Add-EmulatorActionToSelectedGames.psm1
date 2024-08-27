# 添加 Emulator 类型的 GameAction 到选定的游戏
function Add-EmulatorActionToSelectedGames {
    param($menuItemActionArgs)  # 添加参数以接受 ScriptMainMenuItemActionArgs

    $changedCount = 0

    foreach ($game in $PlayniteApi.MainView.SelectedGames) {

        if ($game -eq $null) {
            continue
        }

        # 如果游戏的 GameActions 列表不为空
        if ($game.GameActions -ne $null -and $game.GameActions.Count -gt 0) {
            # 将现有的 IsPlayAction 设置为 false
            foreach ($action in $game.GameActions) {
                if ($action.IsPlayAction) {
                    $action.IsPlayAction = $false
                }
            }
        }

        # 创建新的 GameAction
        $emulatorAction = New-Object Playnite.SDK.Models.GameAction
        $emulatorAction.Name = "Run in Japanese"  # 设置名称
        $emulatorAction.Type = [Playnite.SDK.Models.GameActionType]::Emulator
        $emulatorAction.IsPlayAction = $true  # 设置 IsPlayAction 为勾选状态

        # 设置模拟器和配置
        $emulatorAction.EmulatorId = [Guid]::Parse("d37de673-d1d7-4029-b845-92abd6e12fa6")  # 替换为实际的 EmulatorId
        $emulatorAction.EmulatorProfileId = "#custom_b38afad1-8abd-4e70-aed3-5265a51fc420"  # 设置为 "Run in Japanese" 的配置 ID

        # 添加 GameAction 到游戏的 GameActions 列表
        if ($game.GameActions -eq $null) {
            $game.GameActions = @()
        }

        $game.GameActions.Add($emulatorAction)
        $PlayniteApi.Database.Games.Update($game)
        $changedCount++
    }

    # 使用 Playnite 对话框显示结果
    $PlayniteApi.Dialogs.ShowMessage("Added Emulator action to $changedCount game(s)")
}

# 添加主菜单项目
function GetMainMenuItems {
    param($getMainMenuItemsArgs)

    # 创建菜单项
    $menuItems = @()

    $emulatorMenuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $emulatorMenuItem.Description = "Add Emulator Action to Selected Games"
    $emulatorMenuItem.FunctionName = "Add-EmulatorActionToSelectedGames"
    $menuItems += $emulatorMenuItem

    return $menuItems
}
# 添加右键菜单项目
function GetGameMenuItems {
    param($getGameMenuItemsArgs)

    # 创建菜单项
    $GamemenuItems = @()

    $emulatorGameMenuItem = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
    $emulatorGameMenuItem.Description = "添加Locale Emulator运行指令"
    $emulatorGameMenuItem.FunctionName = "Add-EmulatorActionToSelectedGames"
    $GamemenuItems += $emulatorGameMenuItem

    return $GamemenuItems
}

# 导出函数
Export-ModuleMember -Function Connect-PlayniteSession, Add-EmulatorActionToSelectedGames, GetMainMenuItems, GetGameMenuItems
