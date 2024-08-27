# ��� Emulator ���͵� GameAction ��ѡ������Ϸ
function Add-EmulatorActionToSelectedGames {
    param($menuItemActionArgs)  # ��Ӳ����Խ��� ScriptMainMenuItemActionArgs

    $changedCount = 0

    foreach ($game in $PlayniteApi.MainView.SelectedGames) {

        if ($game -eq $null) {
            continue
        }

        # �����Ϸ�� GameActions �б�Ϊ��
        if ($game.GameActions -ne $null -and $game.GameActions.Count -gt 0) {
            # �����е� IsPlayAction ����Ϊ false
            foreach ($action in $game.GameActions) {
                if ($action.IsPlayAction) {
                    $action.IsPlayAction = $false
                }
            }
        }

        # �����µ� GameAction
        $emulatorAction = New-Object Playnite.SDK.Models.GameAction
        $emulatorAction.Name = "Run in Japanese"  # ��������
        $emulatorAction.Type = [Playnite.SDK.Models.GameActionType]::Emulator
        $emulatorAction.IsPlayAction = $true  # ���� IsPlayAction Ϊ��ѡ״̬

        # ����ģ����������
        $emulatorAction.EmulatorId = [Guid]::Parse("d37de673-d1d7-4029-b845-92abd6e12fa6")  # �滻Ϊʵ�ʵ� EmulatorId
        $emulatorAction.EmulatorProfileId = "#custom_b38afad1-8abd-4e70-aed3-5265a51fc420"  # ����Ϊ "Run in Japanese" ������ ID

        # ��� GameAction ����Ϸ�� GameActions �б�
        if ($game.GameActions -eq $null) {
            $game.GameActions = @()
        }

        $game.GameActions.Add($emulatorAction)
        $PlayniteApi.Database.Games.Update($game)
        $changedCount++
    }

    # ʹ�� Playnite �Ի�����ʾ���
    $PlayniteApi.Dialogs.ShowMessage("Added Emulator action to $changedCount game(s)")
}

# ������˵���Ŀ
function GetMainMenuItems {
    param($getMainMenuItemsArgs)

    # �����˵���
    $menuItems = @()

    $emulatorMenuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $emulatorMenuItem.Description = "Add Emulator Action to Selected Games"
    $emulatorMenuItem.FunctionName = "Add-EmulatorActionToSelectedGames"
    $menuItems += $emulatorMenuItem

    return $menuItems
}
# ����Ҽ��˵���Ŀ
function GetGameMenuItems {
    param($getGameMenuItemsArgs)

    # �����˵���
    $GamemenuItems = @()

    $emulatorGameMenuItem = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
    $emulatorGameMenuItem.Description = "���Locale Emulator����ָ��"
    $emulatorGameMenuItem.FunctionName = "Add-EmulatorActionToSelectedGames"
    $GamemenuItems += $emulatorGameMenuItem

    return $GamemenuItems
}

# ��������
Export-ModuleMember -Function Connect-PlayniteSession, Add-EmulatorActionToSelectedGames, GetMainMenuItems, GetGameMenuItems
