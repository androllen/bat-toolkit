Dim WSHShell

Set WSHShell=WScript.CreateObject("WScript.Shell")

WSHShell.Run "Rundll32.exe user32.dll,LockWorkStation", 0