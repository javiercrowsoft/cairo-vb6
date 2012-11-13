VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_id                       As Long
Private m_cmi_id                   As Long
Private m_account                  As String
Private m_body_html                As String
Private m_body_mime                As String
Private m_body_plain               As String
Private m_body_updated             As Boolean
Private m_fromaddress              As String
Private m_fromname                 As String
Private m_header_mime              As String
Private m_mailid                   As Long
Private m_subject                  As String
Private m_subject_mime             As String
Private m_to                       As String
Private m_cmiea_id                 As Long
Private m_creado                   As Date

Public Property Get id() As Long
   id = m_id
End Property

Public Property Let id(ByVal rhs As Long)
   m_id = rhs
End Property

Public Property Get cmi_id() As Long
   cmi_id = m_cmi_id
End Property

Public Property Let cmi_id(ByVal rhs As Long)
   m_cmi_id = rhs
End Property

Public Property Get account() As String
   account = m_account
End Property

Public Property Let account(ByVal rhs As String)
   m_account = rhs
End Property

Public Property Get body_html() As String
   body_html = m_body_html
End Property

Public Property Let body_html(ByVal rhs As String)
   m_body_html = rhs
End Property

Public Property Get body_mime() As String
   body_mime = m_body_mime
End Property

Public Property Let body_mime(ByVal rhs As String)
   m_body_mime = rhs
End Property

Public Property Get body_plain() As String
   body_plain = m_body_plain
End Property

Public Property Let body_plain(ByVal rhs As String)
   m_body_plain = rhs
End Property

Public Property Get body_updated() As Boolean
   body_updated = m_body_updated
End Property

Public Property Let body_updated(ByVal rhs As Boolean)
   m_body_updated = rhs
End Property

Public Property Get fromaddress() As String
   fromaddress = m_fromaddress
End Property

Public Property Let fromaddress(ByVal rhs As String)
   m_fromaddress = rhs
End Property

Public Property Get fromname() As String
   fromname = m_fromname
End Property

Public Property Let fromname(ByVal rhs As String)
   m_fromname = rhs
End Property

Public Property Get header_mime() As String
   header_mime = m_header_mime
End Property

Public Property Let header_mime(ByVal rhs As String)
   m_header_mime = rhs
End Property

Public Property Get mailid() As Long
   mailid = m_mailid
End Property

Public Property Let mailid(ByVal rhs As Long)
   m_mailid = rhs
End Property

Public Property Get subject() As String
   subject = m_subject
End Property

Public Property Let subject(ByVal rhs As String)
   m_subject = rhs
End Property

Public Property Get subject_mime() As String
   subject_mime = m_subject_mime
End Property

Public Property Let subject_mime(ByVal rhs As String)
   m_subject_mime = rhs
End Property

Public Property Get mailto() As String
   mailto = m_to
End Property

Public Property Let mailto(ByVal rhs As String)
   m_to = rhs
End Property

Public Property Get cmiea_id() As Long
   cmiea_id = m_cmiea_id
End Property

Public Property Let cmiea_id(ByVal rhs As Long)
   m_cmiea_id = rhs
End Property

Public Property Get creado() As Date
   creado = m_creado
End Property

Public Property Let creado(ByVal rhs As Date)
   m_creado = rhs
End Property
