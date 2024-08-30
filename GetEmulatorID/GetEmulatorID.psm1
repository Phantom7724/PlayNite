# PlayniteExtension.psm1

# �����ȡģ������Ϣ��д���ļ��ĺ���
function Write-EmulatorInfoToFileFromMenu {
    param ($args)
    
    # ��ȡ Playnite API �� EmulatorDefinition ��
    $emulators = $PlayniteApi.Database.Emulators
    
    # ����һ��·����������Ϣ�ļ�
    $filePath = "EmulatorInfo.txt"
    
    # ��������ļ�����
    if (Test-Path $filePath) {
        Clear-Content $filePath
    }

    # ��ÿ��ģ��������Ϣд���ļ�
    foreach ($emulator in $emulators) {
        $id = $emulator.ID
        $name = $emulator.Name
        $profiles = $emulator.AllProfiles

        # ���������ļ���Ϣ
        $profilesInfo = $profiles | ForEach-Object {
            "Profile ID: $($_.Id), Name: $($_.Name)"
        }

        $infoLine = "Name: $name`nID: $id`n$profilesInfo`n"
        Add-Content -Path $filePath -Value $infoLine
    }
}

# ������˵���Ŀ
function GetMainMenuItems {
    param($getMainMenuItemsArgs)
    
    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "���ģ������Ϣ"
    $menuItem.FunctionName = "Write-EmulatorInfoToFileFromMenu"  # ������˵�ʱ�����õĺ���
    return $menuItem
}
