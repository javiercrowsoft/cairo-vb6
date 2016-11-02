Option Strict Off
Option Explicit On

Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.ComponentModel
Imports System.Configuration
Imports System.Data
Imports System.Web.Services
Imports System.Diagnostics
Imports System.ServiceProcess
Imports System.IO
Imports CSFacturaElectronica

Namespace CSFEService
  '    using System.Core;


  Public Class WinService1 : Inherits System.ServiceProcess.ServiceBase
    ''' <summary> 
    '''    Required designer variable.
    ''' </summary>
    Private components As System.ComponentModel.Container
    Private m_fe As cFacturaElectronica

    Public Sub New()
      ' This call is required by the WinForms Component Designer.
      InitializeComponent()

      ' TODO: Add any initialization after the InitComponent call
    End Sub

    ' The main entry point for the process
    Shared Sub Main()
      Dim ServicesToRun As System.ServiceProcess.ServiceBase()

      ' More than one user Service may run within the same process. To add
      ' another service to this process, change the following line to
      ' create a second service object. For example,
      '
      '   ServicesToRun = New System.ServiceProcess.ServiceBase[] {new WinService1(), new MySecondUserService()};
      '
      ServicesToRun = New System.ServiceProcess.ServiceBase() {New WinService1()}

      System.ServiceProcess.ServiceBase.Run(ServicesToRun)
    End Sub

    ''' <summary> 
    '''    Required method for Designer support - do not modify 
    '''    the contents of this method with the code editor.
    ''' </summary>
    Private Sub InitializeComponent()
      Me.components = New System.ComponentModel.Container()
      '@this.TrayAutoArrange = true;
      '@this.TrayLargeIcon = false;
      Me.ServiceName = "CSFEService"
    End Sub

    ''' <summary>
    '''    Set things in motion so your service can do its work.
    ''' </summary>
    Protected Overrides Sub OnStart(ByVal args As String())
      m_fe = New cFacturaElectronica
      m_fe.initProcess()
    End Sub

    ''' <summary>
    '''    Stop this service.
    ''' </summary>
    Protected Overrides Sub OnStop()
      m_fe.endProcess()
    End Sub
  End Class
End Namespace