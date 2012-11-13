VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebChartImageStream"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'/////////////////////////////////////////////////////////////////////////////////////////
' CopyRight © 2003-2005 Javier Alvarez (javier@crowsoft.com.ar)

' This library is free software; you can redistribute it and/or modify
' it under the terms of the GNU Lesser Gereral Public Licence as published
' by the Free Software Foundation; either version 2 of the Licence,
' or (at your opinion) any later version.

' This library is distributed in the hope that it will be usefull,
' but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability
' or fitness for a particular purpose. See the GNU Lesser General Public Licence
' for more details.

' You should have received a copy of the GNU Lesser General Public Licence
' along with this library; if not, write to the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, Ma 02111-1307 USA.

' Visit CrowSoft.
'    http://www.crowsoft.com.ar
'/////////////////////////////////////////////////////////////////////////////////////////

'Imports System
'Imports System.Web
'Imports Microsoft.VisualBasic

'Public Class WebChartImageStream
    Implements cIHttpModule


    'Public Event WebChartEvent As WebChartEventHandler
    Public Event WebChartEvent(ByVal s As Object, ByVal e As cEventArgs)

    'Public Delegate Sub WebChartEventHandler(ByVal s As Object, ByVal e As EventArgs)

    Public Sub cIHttpModule_Init(ByVal app As cHttpApplication) 'Implements IHttpModule.Init
        'BeginRequest =AddressOf  (OnBeginRequest)
    End Sub

    Public Sub cIHttpModule_Dispose() 'Implements IHttpModule.Dispose
        'Required Implementation
    End Sub

    Public Sub OnBeginRequest(ByVal s As Object, ByVal e As cEventArgs)
        Dim webApp As cHttpApplication
        Set webApp = s

        If InStr(1, webApp.Request.Path.ToLower, HandlerFileName, vbBinaryCompare) <> 0 Then
            'Getting the WebChart object
            Dim webChartToDraw As cWebChart
            webChartToDraw = _
                webApp.Application.Item(ChartNamePrefixInApplication & _
                                        CStr(webApp.Request.QueryString("id")) _
                                        )
            If webChartToDraw Is Nothing Then
                'WebChart was removed or not found
                'Do nothing.  404 will be returned
            Else
                'Try
                On Error GoTo Catch1
                    'Draw the WebChart to browser
                    With webChartToDraw
                        Dim memStream As cMemoryStream
                        memStream = .RenderWebChartImage()
                        memStream.WriteTo (webApp.Context.Response.OutputStream)
                        .Dispose
                        memStream.CloseStream
                    End With
                    'Stream properties of the WebChart
                    With webApp
                        .Context.ClearError
                        .Response.ContentType = webChartToDraw.HtmlContentType
                        .Response.StatusCode = 200
                        'Remove reference to WebChart
                        .Application.Remove (ChartNamePrefixInApplication & _
                            CStr(.Request.QueryString("id")))
                        .Response.End
                    End With
                'Catch WebChartException As cException
Catch1:     '-->Catch
                    'Error occurred
'           '-->b-End Try
                If Err.Number Then Resume EndCatch1
EndCatch1:
                On Error GoTo 0
'           '-->e-End Try
            End If
        End If

    End Sub


