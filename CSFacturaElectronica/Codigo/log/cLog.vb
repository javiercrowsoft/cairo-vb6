Option Strict Off
Option Explicit On

Imports System.IO
Imports System.Text

Public Class cLog

  Private Shared m_logFileName As String
  Private Shared m_listeners As Collection

  Public Shared Property logFileName()
    Get
      Return m_logFileName
    End Get
    Set(ByVal value)
      m_logFileName = value
    End Set
  End Property

  Public Shared Sub addListener(ByVal listener As ciLogMessage)

    If m_listeners Is Nothing Then
      m_listeners = New Collection
    End If
    m_listeners.Add(listener)

  End Sub

  Public Shared Sub removeListener(ByVal listener As ciLogMessage)

    If m_listeners Is Nothing Then
      Exit Sub
    End If

    Dim l As ciLogMessage
    Dim i As Integer

    While i < m_listeners.Count
      l = m_listeners.Item(i)
      If l Is listener Then
        m_listeners.Remove(i)
        Exit While
      End If
    End While

  End Sub

  Public Shared Sub write(ByVal msg As String, ByVal strTrace As String, ByVal moduleName As String)

    Dim path As String
    path = getAppPath()

    If Not System.IO.Directory.Exists(path & "\log\") Then

      System.IO.Directory.CreateDirectory(path & "\log\")

    End If

    'check the file
    Dim fs As FileStream = New FileStream(path & "\log\" & m_logFileName, FileMode.OpenOrCreate, FileAccess.ReadWrite)
    Dim s As StreamWriter = New StreamWriter(fs)

    s.Close()
    fs.Close()

    'log it
    Dim fs1 As FileStream = New FileStream(path & "\log\" & m_logFileName, FileMode.Append, FileAccess.Write)
    Dim s1 As StreamWriter = New StreamWriter(fs1)

    s1.Write("Title: " & moduleName & vbCrLf)
    s1.Write("Message: " & msg & vbCrLf)
    s1.Write("StackTrace: " & strTrace & vbCrLf)
    s1.Write("Date/Time: " & DateTime.Now.ToString() & vbCrLf)
    s1.Write("================================================" & vbCrLf)

    s1.Close()
    fs1.Close()

    Dim listener As ciLogMessage

    Try

            For Each listener In m_listeners
                listener.message(msg, strTrace, moduleName)
            Next

    Catch ex As Exception

    End Try

  End Sub

  Public Shared Sub show(ByVal msg As String, ByVal strTrace As String, ByVal moduleName As String)

    Dim listener As ciLogMessage

    Try

      For Each listener In m_listeners
        listener.message(msg, strTrace, moduleName)
      Next

    Catch ex As Exception

    End Try

  End Sub

  Public Shared Function getAppPath() As String
    return My.Application.Info.DirectoryPath
  End Function

End Class
