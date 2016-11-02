Option Strict Off
Option Explicit On

Imports Nini.Config
Imports CSLog

Public Class cIni

  Private Const c_module As String = "cIni"

  Private Shared m_fileName As String

  ' standard API declarations for INI access

  Public Shared Function getValue(ByVal section As String, ByVal item As String, ByVal defaultValue As String) As String
    Try

      Dim source As IniConfigSource
      source = New IniConfigSource(m_fileName)
      Return source.Configs(section).Get(item, defaultValue)

    Catch ex As Exception

      cLog.write(ex.Message, "iniValue ***Error:", c_module)
      Return ""

    End Try
  End Function

  Public Shared Sub setValue(ByVal section As Object, ByVal item As String, ByVal value As String)
    Try

      Dim source As IniConfigSource
      source = New IniConfigSource(m_fileName)
      source.Configs(section).Set(item, value)
      source.Save()

    Catch ex As Exception

      cLog.write(ex.Message, "setValue ***Error:", c_module)

    End Try
  End Sub

  Public Shared Sub setIniFileName(ByVal fileName As String)
    m_fileName = cLog.getAppPath() & "\" & fileName
  End Sub
End Class
