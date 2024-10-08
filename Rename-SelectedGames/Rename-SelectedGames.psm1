# 模块文件 MyPlayniteModule.psm1

# Step 2: 配置参数
$global:firstLetterUppercaseAllWords = $true

# Step 3: 修改游戏名称
function Rename-SelectedGames {
    param($menuItemActionArgs)  # 添加参数以接受 ScriptMainMenuItemActionArgs

    $changedCount = 0
    $textInfo = (Get-Culture).TextInfo

    # $PlayniteApi.MainView.SelectedGames 可以修改为 $PlayniteApi.Database.Games 来处理 Playnite 数据库中的所有游戏
    foreach ($game in $PlayniteApi.MainView.SelectedGames) {

        if ([string]::IsNullOrEmpty($game.InstallDirectory)) {
            continue
        }

        $newName = $game.InstallDirectory.TrimEnd("\").Split('\')[-1] -replace " \[.+\]$", ""
        if ($firstLetterUppercaseAllWords -eq $true) {
            $newName = $textInfo.ToTitleCase($newName)
        }

        # 跳过名称相同的游戏，防止不必要的处理
        if ([string]::IsNullOrEmpty($newName) -or $game.Name -eq $newName) {
            continue
        }

        $game.Name = $newName
        $PlayniteApi.Database.Games.Update($game)
        $changedCount++
    }

    # 使用 Playnite 对话框显示结果
    $PlayniteApi.Dialogs.ShowMessage("已为 $changedCount 个游戏重命名")
}

# 添加主菜单项目
function GetMainMenuItems {
    param($getMainMenuItemsArgs)

    # 创建一个新的菜单项
    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "选择游戏 重命名为文件夹名"
    $menuItem.FunctionName = "Rename-SelectedGames"  # 当点击菜单时，调用的函数
    return $menuItem
}

# 导出函数
Export-ModuleMember -Function Connect-PlayniteSession, Rename-SelectedGames, GetMainMenuItems
