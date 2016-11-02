Imports CSLog

Public Class cLogMessage
  Implements ciLogMessage

  Public Sub message(ByVal msg As String, ByVal strTrace As String, ByVal moduleName As String) Implements CSLog.ciLogMessage.message
        System.Console.Out.WriteLine("*******************")
        System.Console.Out.WriteLine("**")
        System.Console.Out.WriteLine("")
        System.Console.Out.WriteLine(moduleName)
        System.Console.Out.WriteLine(strTrace)
        System.Console.Out.WriteLine(msg)
  End Sub
End Class
