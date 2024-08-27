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
        $emulatorAction.Name = "Emulator Action"  # ���Ը�����Ҫ��������
        $emulatorAction.Type = [Playnite.SDK.Models.GameActionType]::Emulator
        $emulatorAction.Path = ""  # ������ض���·�������������
        $emulatorAction.Arguments = ""  # ������ض��Ĳ��������������
        $emulatorAction.WorkingDir = ""  # ������ض��Ĺ���Ŀ¼�����������
        $emulatorAction.IsPlayAction = $true  # ���� IsPlayAction Ϊ��ѡ״̬

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

# ��������
Export-ModuleMember -Function Connect-PlayniteSession, Add-EmulatorActionToSelectedGames, GetMainMenuItems
