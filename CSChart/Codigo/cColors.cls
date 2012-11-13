VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColors"
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

Private m_coll As Collection

Private Sub pFill()
  m_coll.Add colors.AliceBlue   '= &HFFF0F8FF
  m_coll.Add colors.AntiqueWhite '= &HFFFAEBD7
  m_coll.Add colors.Aqua '= &HFF00FFFF
  m_coll.Add colors.Aquamarine '= &HFF7FFFD4
  m_coll.Add colors.Azure '= &HFFF0FFFF
  m_coll.Add colors.Beige '= &HFFF5F5DC
  m_coll.Add colors.Bisque '= &HFFFFE4C4
  m_coll.Add colors.Black '= &HFF000000
  m_coll.Add colors.BlanchedAlmond '= &HFFFFEBCD
  m_coll.Add colors.Blue '= &HFF0000FF
  m_coll.Add colors.BlueViolet '= &HFF8A2BE2
  m_coll.Add colors.Brown '= &HFFA52A2A
  m_coll.Add colors.BurlyWood '= &HFFDEB887
  m_coll.Add colors.CadetBlue '= &HFF5F9EA0
  m_coll.Add colors.Chartreuse '= &HFF7FFF00
  m_coll.Add colors.Chocolate '= &HFFD2691E
  m_coll.Add colors.Coral '= &HFFFF7F50
  m_coll.Add colors.CornflowerBlue '= &HFF6495ED
  m_coll.Add colors.Cornsilk '= &HFFFFF8DC
  m_coll.Add colors.Crimson '= &HFFDC143C
  m_coll.Add colors.Cyan '= &HFF00FFFF
  m_coll.Add colors.DarkBlue '= &HFF00008B
  m_coll.Add colors.DarkCyan '= &HFF008B8B
  m_coll.Add colors.DarkGoldenrod '= &HFFB8860B
  m_coll.Add colors.DarkGray '= &HFFA9A9A9
  m_coll.Add colors.DarkGreen '= &HFF006400
  m_coll.Add colors.DarkKhaki '= &HFFBDB76B
  m_coll.Add colors.DarkMagenta '= &HFF8B008B
  m_coll.Add colors.DarkOliveGreen '= &HFF556B2F
  m_coll.Add colors.DarkOrange '= &HFFFF8C00
  m_coll.Add colors.DarkOrchid '= &HFF9932CC
  m_coll.Add colors.DarkRed '= &HFF8B0000
  m_coll.Add colors.DarkSalmon '= &HFFE9967A
  m_coll.Add colors.DarkSeaGreen '= &HFF8FBC8B
  m_coll.Add colors.DarkSlateBlue '= &HFF483D8B
  m_coll.Add colors.DarkSlateGray '= &HFF2F4F4F
  m_coll.Add colors.DarkTurquoise '= &HFF00CED1
  m_coll.Add colors.DarkViolet '= &HFF9400D3
  m_coll.Add colors.DeepPink '= &HFFFF1493
  m_coll.Add colors.DeepSkyBlue '= &HFF00BFFF
  m_coll.Add colors.DimGray '= &HFF696969
  m_coll.Add colors.DodgerBlue '= &HFF1E90FF
  m_coll.Add colors.Firebrick '= &HFFB22222
  m_coll.Add colors.FloralWhite '= &HFFFFFAF0
  m_coll.Add colors.ForestGreen '= &HFF228B22
  m_coll.Add colors.Fuchsia '= &HFFFF00FF
  m_coll.Add colors.Gainsboro '= &HFFDCDCDC
  m_coll.Add colors.GhostWhite '= &HFFF8F8FF
  m_coll.Add colors.Gold '= &HFFFFD700
  m_coll.Add colors.Goldenrod '= &HFFDAA520
  m_coll.Add colors.Gray '= &HFF808080
  m_coll.Add colors.Green '= &HFF008000
  m_coll.Add colors.GreenYellow '= &HFFADFF2F
  m_coll.Add colors.Honeydew '= &HFFF0FFF0
  m_coll.Add colors.HotPink '= &HFFFF69B4
  m_coll.Add colors.IndianRed '= &HFFCD5C5C
  m_coll.Add colors.Indigo '= &HFF4B0082
  m_coll.Add colors.Ivory '= &HFFFFFFF0
  m_coll.Add colors.Khaki '= &HFFF0E68C
  m_coll.Add colors.Lavender '= &HFFE6E6FA
  m_coll.Add colors.LavenderBlush '= &HFFFFF0F5
  m_coll.Add colors.LawnGreen '= &HFF7CFC00
  m_coll.Add colors.LemonChiffon '= &HFFFFFACD
  m_coll.Add colors.LightBlue '= &HFFADD8E6
  m_coll.Add colors.LightCoral '= &HFFF08080
  m_coll.Add colors.LightCyan '= &HFFE0FFFF
  m_coll.Add colors.LightGoldenrodYellow '= &HFFFAFAD2
  m_coll.Add colors.LightGray '= &HFFD3D3D3
  m_coll.Add colors.LightGreen '= &HFF90EE90
  m_coll.Add colors.LightPink '= &HFFFFB6C1
  m_coll.Add colors.LightSalmon '= &HFFFFA07A
  m_coll.Add colors.LightSeaGreen '= &HFF20B2AA
  m_coll.Add colors.LightSkyBlue '= &HFF87CEFA
  m_coll.Add colors.LightSlateGray '= &HFF778899
  m_coll.Add colors.LightSteelBlue '= &HFFB0C4DE
  m_coll.Add colors.LightYellow '= &HFFFFFFE0
  m_coll.Add colors.Lime '= &HFF00FF00
  m_coll.Add colors.LimeGreen '= &HFF32CD32
  m_coll.Add colors.Linen '= &HFFFAF0E6
  m_coll.Add colors.Magenta '= &HFFFF00FF
  m_coll.Add colors.Maroon '= &HFF800000
  m_coll.Add colors.MediumAquamarine '= &HFF66CDAA
  m_coll.Add colors.MediumBlue '= &HFF0000CD
  m_coll.Add colors.MediumOrchid '= &HFFBA55D3
  m_coll.Add colors.MediumPurple '= &HFF9370DB
  m_coll.Add colors.MediumSeaGreen '= &HFF3CB371
  m_coll.Add colors.MediumSlateBlue '= &HFF7B68EE
  m_coll.Add colors.MediumSpringGreen '= &HFF00FA9A
  m_coll.Add colors.MediumTurquoise '= &HFF48D1CC
  m_coll.Add colors.MediumVioletRed '= &HFFC71585
  m_coll.Add colors.MidnightBlue '= &HFF191970
  m_coll.Add colors.MintCream '= &HFFF5FFFA
  m_coll.Add colors.MistyRose '= &HFFFFE4E1
  m_coll.Add colors.Moccasin '= &HFFFFE4B5
  m_coll.Add colors.NavajoWhite '= &HFFFFDEAD
  m_coll.Add colors.Navy '= &HFF000080
  m_coll.Add colors.OldLace '= &HFFFDF5E6
  m_coll.Add colors.Olive '= &HFF808000
  m_coll.Add colors.OliveDrab '= &HFF6B8E23
  m_coll.Add colors.Orange '= &HFFFFA500
  m_coll.Add colors.OrangeRed '= &HFFFF4500
  m_coll.Add colors.Orchid '= &HFFDA70D6
  m_coll.Add colors.PaleGoldenrod '= &HFFEEE8AA
  m_coll.Add colors.PaleGreen '= &HFF98FB98
  m_coll.Add colors.PaleTurquoise '= &HFFAFEEEE
  m_coll.Add colors.PaleVioletRed '= &HFFDB7093
  m_coll.Add colors.PapayaWhip '= &HFFFFEFD5
  m_coll.Add colors.PeachPuff '= &HFFFFDAB9
  m_coll.Add colors.Peru '= &HFFCD853F
  m_coll.Add colors.Pink '= &HFFFFC0CB
  m_coll.Add colors.Plum '= &HFFDDA0DD
  m_coll.Add colors.PowderBlue '= &HFFB0E0E6
  m_coll.Add colors.Purple '= &HFF800080
  m_coll.Add colors.Red '= &HFFFF0000
  m_coll.Add colors.RosyBrown '= &HFFBC8F8F
  m_coll.Add colors.RoyalBlue '= &HFF4169E1
  m_coll.Add colors.SaddleBrown '= &HFF8B4513
  m_coll.Add colors.Salmon '= &HFFFA8072
  m_coll.Add colors.SandyBrown '= &HFFF4A460
  m_coll.Add colors.SeaGreen '= &HFF2E8B57
  m_coll.Add colors.SeaShell '= &HFFFFF5EE
  m_coll.Add colors.Sienna '= &HFFA0522D
  m_coll.Add colors.Silver '= &HFFC0C0C0
  m_coll.Add colors.SkyBlue '= &HFF87CEEB
  m_coll.Add colors.SlateBlue '= &HFF6A5ACD
  m_coll.Add colors.SlateGray '= &HFF708090
  m_coll.Add colors.Snow '= &HFFFFFAFA
  m_coll.Add colors.SpringGreen '= &HFF00FF7F
  m_coll.Add colors.SteelBlue '= &HFF4682B4
  m_coll.Add colors.Tan '= &HFFD2B48C
  m_coll.Add colors.Teal '= &HFF008080
  m_coll.Add colors.Thistle '= &HFFD8BFD8
  m_coll.Add colors.Tomato '= &HFFFF6347
  m_coll.Add colors.Transparent '= &HFFFFFF
  m_coll.Add colors.Turquoise '= &HFF40E0D0
  m_coll.Add colors.Violet '= &HFFEE82EE
  m_coll.Add colors.Wheat '= &HFFF5DEB3
  m_coll.Add colors.White '= &HFFFFFFFF
  m_coll.Add colors.WhiteSmoke '= &HFFF5F5F5
  m_coll.Add colors.Yellow '= &HFFFFFF00
  m_coll.Add colors.YellowGreen '= &HFF9ACD32
End Sub

Public Function Count() As Long
  Count = m_coll.Count()
End Function

Public Function Item(ByVal idx As Integer) As GpGDIPlus.colors
  If idx Mod m_coll.Count > 0 Then idx = idx Mod m_coll.Count
  Item = m_coll.Item(idx)
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_coll = New Collection
  pFill
End Sub

Private Sub Class_Terminate()
  Set m_coll = Nothing
End Sub


