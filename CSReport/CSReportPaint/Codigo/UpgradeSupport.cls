VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "UpgradeSupport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Module UpgradeSupport
    Friend cReportDeclaration_definst As cReportDeclaration = New cReportDeclaration
    Friend CSKernelClientcMouse_definst As CSKernelClient.cMouse = New CSKernelClient.cMouse
    Friend CSKernelClientcDeclarations_definst As CSKernelClient.cDeclarations = New CSKernelClient.cDeclarations
    Friend CSKernelClientcInitKernelClient_definst As CSKernelClient.cInitKernelClient = New CSKernelClient.cInitKernelClient
    Friend CSKernelClientcWindow_definst As CSKernelClient.cWindow = New CSKernelClient.cWindow
    Friend CSKernelClientcDeclarationsError_definst As CSKernelClient.cDeclarationsError = New CSKernelClient.cDeclarationsError
    Friend CSKernelClientcError_definst As CSKernelClient.cError = New CSKernelClient.cError
    Friend CSKernelClientcUtil_definst As CSKernelClient.cUtil = New CSKernelClient.cUtil
    Friend CSReportDllcReportDeclaration_definst As CSReportDll.cReportDeclaration = New CSReportDll.cReportDeclaration
    Friend CSReportDllcCSConnectDeclaration_definst As CSReportDll.cCSConnectDeclaration = New CSReportDll.cCSConnectDeclaration
End Module
