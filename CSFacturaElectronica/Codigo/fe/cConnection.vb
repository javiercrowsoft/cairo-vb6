Option Strict Off
Option Explicit On

Imports System.Data
Imports system.Data.OleDb
Imports CSLog

Friend Class cConnection

  Implements IDisposable
  '--------------------------------------------------------------------------------
  ' cConection
  ' 15-05-2002

  '--------------------------------------------------------------------------------
  ' notas:
  ' Proposito:   Contiene una conexion con un servidor sql

  '--------------------------------------------------------------------------------
  ' api win32
  ' constantes
  ' estructuras
  ' funciones

  '--------------------------------------------------------------------------------

  ' constantes
  Private Const c_module As String = "cConection"
  ' estructuras
  ' variables privadas
  Private m_Server As OleDbConnection
  Private m_Connected As Boolean
  ' eventos
  ' propiedades publicas
  Public ReadOnly Property Server() As OleDbConnection
    Get
      Server = m_Server
    End Get
  End Property

  Public ReadOnly Property Connected() As Boolean
    Get
      Connected = m_Connected
    End Get
  End Property

  Public ReadOnly Property ServerName() As String
    Get

      ServerName = ""
      Try

        If Not m_Connected Then Exit Property
        If m_Server Is Nothing Then Exit Property

        ServerName = m_Server.DataSource

      Catch ex As Exception

        cLog.write(ex.Message, "ServerName", c_module)

      End Try
    End Get
  End Property

  ' propiedades privadas
  ' funciones publicas
  Public Function Execute(ByVal sqlstmt As String) As Boolean
    Try

      Dim sqlCommand As OleDbCommand
      sqlCommand = m_Server.CreateCommand()
      sqlCommand.CommandText = sqlstmt
      sqlCommand.CommandTimeout = 7200
      sqlCommand.ExecuteNonQuery()

      Execute = True

    Catch ex As Exception

      cLog.write(ex.Message, "Execute", c_module)

      Execute = False

    End Try
  End Function

  Public Function OpenConnectionEx(ByVal ServerName As String, ByVal User As String, ByVal Password As String, ByVal UseTrusted As Boolean, ByVal DataBase As String, ByVal bSilent As Boolean, Optional ByRef strError As String = "") As Boolean
    OpenConnectionEx = pOpenConnection(ServerName, User, Password, UseTrusted, True, DataBase, bSilent, strError)
  End Function

  Private Function pOpenConnection(ByVal ServerName As String, ByVal User As String, ByVal Password As String, ByVal UseTrusted As Boolean, ByVal bDontShowError As Boolean, ByVal DataBase As String, ByVal bSilent As Boolean, Optional ByRef strError As String = "") As Boolean
    Try

      If m_Server Is Nothing Then m_Server = New OleDbConnection

      CloseConnection()

      Dim strConnect As Object

      If UseTrusted Then
        strConnect = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;User ID=@@user@@;Initial Catalog=@@database@@;Data Source=@@SERVER@@"
      Else
        strConnect = "Provider=SQLOLEDB.1;Password=@@password@@;Persist Security Info=True;User ID=@@user@@;Initial Catalog=@@database@@;Data Source=@@SERVER@@"
      End If

      strConnect = Replace(strConnect, "@@SERVER@@", ServerName)
      strConnect = Replace(strConnect, "@@user@@", User)
      strConnect = Replace(strConnect, "@@password@@", Password)
      strConnect = Replace(strConnect, "@@database@@", DataBase)

      'cLog.show("server: " & ServerName & vbCrLf & _
      '           "user: " & User & vbCrLf & _
      '           "password: " & Password & vbCrLf & _
      '           "database: " & DataBase, _
      '           "pOpenConnection: Abriendo Conexión", c_module)

      m_Server.ConnectionString = strConnect
      m_Server.Open()

      'cLog.write("Conexión abierta con éxito", "OpenConnection", c_module)

      m_Connected = True
      pOpenConnection = True

    Catch ex As Exception

      strError = ex.Message
      If Not bSilent Then
        cLog.write(ex.Message, "OpenConnection", c_module)
      End If
    End Try
  End Function

  Public Function CloseConnection() As Boolean
    Try

      If m_Connected Then

        If Not m_Server Is Nothing Then

          If m_Server.State <> ConnectionState.Closed Then

            m_Server.Close()

          End If
        End If

        m_Connected = False

      End If

      CloseConnection = True

    Catch ex As Exception

      cLog.write(ex.Message, "CloseConnection", c_module)

    End Try
  End Function

  Public Function openRs(ByVal sqlstmt As String, ByRef rs As DataSet) As Boolean
    Try

      Dim da As OleDbDataAdapter

      da = New OleDbDataAdapter(sqlstmt, m_Server)
      rs = New DataSet()
      da.Fill(rs, "table1")

      Return True

    Catch ex As Exception

      cLog.write(ex.Message, "ListDataBases", c_module)
      Return False

    End Try
  End Function

  ' funciones friend
  ' funciones privadas
  ' construccion - destruccion
  Private Sub ClassInitialize()
    Try

      m_Server = New OleDbConnection

    Catch ex As Exception

      cLog.write(ex.Message, "ClassInitialize", c_module)

    End Try
  End Sub

  Public Sub New()
    MyBase.New()
    ClassInitialize()
  End Sub

  Private Sub ClassTerminate()
    Try

      CloseConnection()
      m_Server.Dispose()
      m_Server = Nothing

    Catch ex As Exception

      cLog.write(ex.Message, "ClassTerminate", c_module)

    End Try
  End Sub

  Protected Overrides Sub Finalize()
    Dispose()
    MyBase.Finalize()
  End Sub

  Public Overloads Sub Dispose() Implements IDisposable.Dispose
    Dispose(True)
    GC.SuppressFinalize(Me)
  End Sub

  Protected Overridable Overloads Sub Dispose(ByVal disposing As Boolean)
    If disposing Then
      ClassTerminate()
    End If
  End Sub

End Class