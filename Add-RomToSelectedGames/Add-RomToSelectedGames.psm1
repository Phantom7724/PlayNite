# ���ROM����Ϸ����
function Add-RomToSelectedGames {
    param($menuItemActionArgs)  # ��Ӳ����Խ��� ScriptMainMenuItemActionArgs

    $changedCount = 0

    foreach ($game in $PlayniteApi.MainView.SelectedGames) {

        if ($game -eq $null -or [string]::IsNullOrEmpty($game.InstallDirectory)) {
            continue
        }

        # ����Ҫʹ�õ�һ�� GameAction ��·��
        $romPath = $null
        if ($game.GameActions -ne $null -and $game.GameActions.Count -gt 0) {
            # ��ȡ��һ�� GameAction ��·����Ϊ ROM ·��
            $firstAction = $game.GameActions[0]
            $romPath = $firstAction.Path
        }

        if ([string]::IsNullOrEmpty($romPath)) {
            # ��� GameAction ��û��·����ʹ����Ϸ�� InstallDirectory
            $romPath = $game.InstallDirectory
        }

        # ��� ROM
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

    # ʹ�� Playnite �Ի�����ʾ���
    $PlayniteApi.Dialogs.ShowMessage("Added ROM to $changedCount game(s)")
}

# ������˵���Ŀ
function GetMainMenuItems {
    param($getMainMenuItemsArgs)

    # �����˵���
    $menuItems = @()

    $romMenuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $romMenuItem.Description = "Add ROM to Selected Games"
    $romMenuItem.FunctionName = "Add-RomToSelectedGames"
    $menuItems += $romMenuItem

    return $menuItems
}

# ��������
Export-ModuleMember -Function Connect-PlayniteSession, Add-RomToSelectedGames, Add-ActionToSelectedGames, GetMainMenuItems
