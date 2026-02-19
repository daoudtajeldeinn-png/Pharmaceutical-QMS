' PharmaQMS Enterprise - Stealth Launcher
' This script starts the background server without showing any console windows.

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the directory where the script is located
strScriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
strBatPath = strScriptPath & "\START_SILENT.bat"

If fso.FileExists(strBatPath) Then
    ' Run the batch file hidden
    WshShell.Run "cmd /c " & Chr(34) & strBatPath & Chr(34), 0, False
Else
    MsgBox "Error: Command file (START_SILENT.bat) not found!", 16, "PharmaQMS Launcher"
End If
