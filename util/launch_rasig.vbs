command = "ruby " & Wscript.ScriptFullName & "\..\rasig"
CreateObject("WScript.Shell").Run "cmd /c " & command, vbHide, False
