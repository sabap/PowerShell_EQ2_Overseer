$ScriptDir = Get-Location
$CSVDir = "$ScriptDir\Working"
$QuestFileLocation = Get-ChildItem -Path $CSVDir | Where-Object Name -Like "*Quest*.csv" | Select-Object FullName
$AgentFileLocation = Get-ChildItem -Path $CSVDir | Where-Object Name -Like "*Agent*.csv" | Select-Object FullName
$OverseerAgentCSVFile = Import-CSV -Path $AgentFileLocation.FullName
$OverseerQuestCSVFile = Import-CSV -Path $QuestFileLocation.FullName
$TempCharFile = "$CSVDir/TempChar.csv"
$TempAcctFile = "$CSVDir/TempAcct.csv"
$TempCharHeader = "VarNum,ToonName"
$TempAcctHeader = "VarNum,AcctName"
Add-Content -Path $TempCharFile -Value $TempCharHeader
Add-Content -Path $TempAcctFile -Value $TempAcctHeader
# ------------Choose Character ------------------------
$Characters = $OverseerAgentCSVFile | Get-member -MemberType 'NoteProperty' | Where-Object Name -notmatch "_" | Select-Object -ExpandProperty 'Name'
$CharNum = 0
ForEach ($Character in $Characters)
    {
        $CharNum = $CharNum + 1
        $Content = "$CharNum" + "," + $Character
        Add-Content -Path $TempCharFile -Value $Content
        Write-Host "$CharNum - $Character"
    }
    $ChosenChar = Read-Host -Prompt "What character do you want to use?"
    $ChosenChar = Import-CSV -Path $TempCharFile | Where-Object VarNum -eq $ChosenChar | Select-Object ToonName
    $ChosenChar = $ChosenChar.ToonName
    Write-Host "You have chosen"$ChosenChar
# ------------Choose Account ------------------------
$Accounts = $OverseerQuestCSVFile | Get-member -MemberType 'NoteProperty' | Where-Object Name -notmatch "_" | Select-Object -ExpandProperty 'Name'
$AcctNum = 0
ForEach ($Account in $Accounts)
    {
        $AcctNum = $AcctNum + 1
        $Content = "$AcctNum" + "," + $Account
        Add-Content -Path $TempAcctFile -Value $Content
        Write-Host "$AcctNum - $Account"
    }
$ChosenAcct = Read-Host -Prompt "To Which Account does $ChosenChar reside?"
$ChosenAcct = Import-CSV -Path $TempAcctFile | Where-Object VarNum -eq $ChosenAcct | Select-Object AcctName
$ChosenAcct = $ChosenAcct.AcctName
Write-Host "You have chosen"$ChosenAcct
$CharacterAgents = $OverseerAgentCSVFile | Where-Object $ChosenChar -eq "1"
$AccountQuests = $OverseerQuestCSVFile | Where-Object $ChosenAcct -eq "1"
ForEach ($QuestName in $AccountQuests)
    {
        #$QuestForegroundColor = "White"
        If($QuestName.Quest_Type -eq "4"){$QuestForegroundColor = "Green"}
        If($QuestName.Quest_Type -eq "3"){$QuestForegroundColor = "Magenta"}
        If($QuestName.Quest_Type -eq "2"){$QuestForegroundColor = "Yellow"}
        If($QuestName.Quest_Type -eq "1"){$QuestForegroundColor = "Cyan"}
        Write-Host ""$QuestName.Quest_Name -ForegroundColor "$QuestForegroundColor"
    }


Remove-Item -Path $TempCharFile,$TempAcctFile -Force