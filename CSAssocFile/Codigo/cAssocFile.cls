VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAssocFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const K_SECTION     As String = "CONFIG"

Private m_question          As String
Private m_yesButton         As String
Private m_noButton          As String
Private m_dontAsk           As String

Public Property Let Question(ByVal rhs As String)
    m_question = rhs
End Property

Public Property Let YesButton(ByVal rhs As String)
    m_yesButton = rhs
End Property

Public Property Let NoButton(ByVal rhs As String)
    m_noButton = rhs
End Property

Public Property Let DontAsk(ByVal rhs As String)
    m_dontAsk = rhs
End Property

Public Function GetLongFileName(ByVal FullFileName As String) As String
    GetLongFileName = mApi.GetLongFileName(FullFileName)
End Function

Public Function GetAssociatedApp(ByVal FullFileName As String) As String
    GetAssociatedApp = mApi.GetAssociatedApp(FullFileName)
End Function

Public Sub AssociateFileExtension(ByVal Extension As String, _
                                  ByVal PathToExecute As String, _
                                  ByVal ApplicationName As String)
    mApi.AssociateFileExtension Extension, _
                                PathToExecute, _
                                ApplicationName
End Sub

Public Sub UnAssociateFileExtension(ByVal Extension As String, _
                                    ByVal ApplicationName As String)
    mApi.UnAssociateFileExtension Extension, _
                                  ApplicationName
End Sub
                        
Public Function ValidateAssociation(ByVal Extension As String, _
                                    ByVal PathToExecute As String, _
                                    ByVal ApplicationName As String)

    Dim LongPathToExecute       As String
    Dim LongPathAssociated      As String
    
    LongPathToExecute = GetLongFileName(PathToExecute)
    LongPathAssociated = GetLongFileName(GetAssociatedApp(pGetTempFile(Extension)))
    
    pDelTempFile Extension
    
    If LongPathToExecute <> LongPathAssociated Then
    
        If pAsk(Extension, PathToExecute) Then
    
            With fAsk
                .lbQuestion.Caption = Replace(m_question, "%1", Extension)
                .chkDontAsk.Caption = m_dontAsk
                .cmdNo.Caption = m_noButton
                .cmdYes.Caption = m_yesButton
                
                .Show vbModal
                
                If .Yes Then
                    AssociateFileExtension Extension, _
                                           PathToExecute, _
                                           ApplicationName
                Else
                    If .chkDontAsk.Value = vbChecked Then
                        pSaveNotAsk Extension, PathToExecute
                    End If
                End If
            End With
        End If
    End If
End Function

Private Function pAsk(ByVal Extension As String, _
                      ByVal PathToExecute As String) As Boolean
    Dim KeyVal As String
    
    KeyVal = GetSetting(App.EXEName, K_SECTION, Extension, "")
    
    pAsk = InStr(1, KeyVal, PathToExecute, vbTextCompare) = 0
End Function

Private Function pSaveNotAsk(ByVal Extension As String, _
                             ByVal PathToExecute As String) As Boolean
    SaveSetting App.EXEName, K_SECTION, Extension, _
                GetSetting(App.EXEName, K_SECTION, Extension, "") & _
                PathToExecute & "|"
End Function

Private Function pGetTempFile(ByVal Extension As String) As String
    Dim file        As Integer
    Dim strFile     As String
    
    file = FreeFile
    strFile = Environ$("TEMP") & "\_Aux_Asoc_." & Extension
    Open strFile For Output As #file
    Close #file
    pGetTempFile = strFile
End Function

Private Sub pDelTempFile(ByVal Extension As String)
    Kill pGetTempFile(Extension)
End Sub
