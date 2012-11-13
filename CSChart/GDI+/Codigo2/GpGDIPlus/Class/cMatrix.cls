VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMatrix"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cMatrix.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusMatrix.h:Microsoft Platform SDK February 2003
'
' A Matrix object represents a 3 ¡Á3 matrix that, in turn, represents an affine
' transformation. A Matrix object stores only six of the 9 numbers in a 3 ¡Á3 matrix
' because all 3 ¡Á3 matrices that represent affine transformations have the same
' third column (0, 0, 1).
' ==================================================================================

Private m_lngMatrix As Long
Private m_lngRegion As Long
Private m_uLastStatus As GpStatus

' creates a new Matrix object that is a copy of this Matrix object.
Public Function Clone() As cMatrix
    Dim lngMatrix       As Long
    Dim clsClone        As cMatrix
    
    m_uLastStatus = GdipCloneImage(m_lngMatrix, lngMatrix)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cImage
    clsClone.fInitialize (lngMatrix)
    Set Clone = clsClone
End Function

' Creates and initializes a Matrix object based on six numbers that define an affine transformation.
Public Function Create(ByVal m11 As Single, _
                       ByVal m12 As Single, _
                       ByVal m21 As Single, _
                       ByVal m22 As Single, _
                       ByVal dx As Single, _
                       ByVal dy As Single) As GpStatus
    Call DisposeMatrix
    m_uLastStatus = GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, m_lngMatrix)
    Create = m_uLastStatus
End Function

' Creates a Matrix object based on a rectangle and a point.
Public Function CreateRectPointF(ByVal rect As cRectF, ByVal pt As cPointF)
    Call DisposeMatrix
    m_uLastStatus = GdipCreateMatrix3(rect.ToType, pt.ToType, m_lngMatrix)
    CreateRectPointF = m_uLastStatus
End Function

' Creates a Matrix object based on a rectangle and a point.
Public Function CreateRectPointL(ByVal rect As cRect, ByVal pt As cPoint)
    Call DisposeMatrix
    m_uLastStatus = GdipCreateMatrix3I(rect.ToType, pt.ToType, m_lngMatrix)
    CreateRectPointL = m_uLastStatus
End Function

Public Sub DisposeMatrix()
    If m_lngMatrix <> 0 Then m_uLastStatus = GdipDeleteMatrix(m_lngMatrix): m_lngMatrix = 0
End Sub

' determines whether the elements of this matrix are equal to the elements of another matrix.
Public Function Equals(ByVal matrix As cMatrix) As Boolean
    Dim lngEqual As Long
    
    m_uLastStatus = GdipIsMatrixEqual(m_lngMatrix, matrix.NativeMatrix, lngEqual)
    Equals = lngEqual
End Function

Friend Sub fInitialize(ByVal matrix As Long)
    Call DisposeMatrix
    m_lngMatrix = matrix
End Sub

' gets the elements of this matrix. The elements are placed in an array in the order
' m11, m12, m21, m22, m31, m32, where mij denotes the element in row i, column j.
Public Function GetElements(m() As Single) As GpStatus
    ReDim m(0 To 5) As Single
    m_uLastStatus = GdipGetMatrixElements(m_lngMatrix, m(0))
    GetElements = m_uLastStatus
End Function

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' If this matrix is invertible, the Invert method replaces the elements of this
' matrix with the elements of its inverse.
Public Function Invert() As GpStatus
    m_uLastStatus = GdipInvertMatrix(m_lngMatrix)
    Invert = m_uLastStatus
End Function

' determines whether this matrix is the identity matrix.
Public Function IsIdentity() As Boolean
    Dim lngResult As Long
    
    m_uLastStatus = GdipIsMatrixIdentity(m_lngMatrix, lngResult)
    IsIdentity = lngResult
End Function

' determines whether this matrix is invertible.
Public Function IsInvertible() As Boolean
    Dim lngResult As Long
    
    m_uLastStatus = GdipIsMatrixInvertible(m_lngMatrix, lngResult)
    IsInvertible = lngResult
End Function

' updates this matrix with the product of itself and another matrix.
Public Function Multiply(ByVal matrix As cMatrix, Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipMultiplyMatrix(m_lngMatrix, matrix.NativeMatrix, uOrder)
    Multiply = m_uLastStatus
End Function

Public Property Get NativeMatrix() As Long
    NativeMatrix = m_lngMatrix
End Property

' gets the horizontal translation value of this matrix, which is the element in row 3, column 1.
Public Function offsetX() As Single
    Dim sElements() As Single
    
    If GetElements(sElements) = Ok Then
       offsetX = sElements(4)
    Else
       offsetX = 0
    End If
End Function

' gets the vertical translation value of this matrix, which is the element in row 3, column 2.
Public Function offsetY() As Single
    Dim sElements() As Single
    
    If GetElements(sElements) = Ok Then
       offsetY = sElements(5)
    Else
       offsetY = 0
    End If
End Function

' updates this matrix with the elements of the identity matrix.
Public Function Reset() As GpStatus
    m_uLastStatus = GdipSetMatrixElements(m_lngMatrix, 1, 0, 0, 1, 0, 0)
    Reset = m_uLastStatus
End Function

' updates this matrix with the product of itself and a rotation matrix.
Public Function Rotate(ByVal angle As Single, Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipRotateMatrix(m_lngMatrix, angle, uOrder)
    Rotate = m_uLastStatus
End Function

' updates this matrix with the product of itself and a matrix that represents rotation about a specified point.
Public Function RotateAt(ByVal angle As Single, ByVal center As cPointF, _
                         Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    If uOrder = MatrixOrderPrepend Then
       m_uLastStatus = GdipTranslateMatrix(m_lngMatrix, center.x, center.y, uOrder)
       m_uLastStatus = GdipRotateMatrix(m_lngMatrix, angle, uOrder)
       m_uLastStatus = GdipTranslateMatrix(m_lngMatrix, -center.x, -center.y, uOrder)
    Else
       m_uLastStatus = GdipTranslateMatrix(m_lngMatrix, -center.x, -center.y, uOrder)
       m_uLastStatus = GdipRotateMatrix(m_lngMatrix, angle, uOrder)
       m_uLastStatus = GdipTranslateMatrix(m_lngMatrix, center.x, center.y, uOrder)
    End If
    RotateAt = m_uLastStatus
End Function

' updates this matrix with the product of itself and a scaling matrix.
Public Function ScaleMatrix(ByVal scaleX As Single, ByVal scaleY As Single, _
                            Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipScaleMatrix(m_lngMatrix, scaleX, scaleY, uOrder)
    ScaleMatrix = m_uLastStatus
End Function

' sets the elements of this matrix.
Public Function SetElements(ByVal m11 As Single, _
                            ByVal m12 As Single, _
                            ByVal m21 As Single, _
                            ByVal m22 As Single, _
                            ByVal dx As Single, _
                            ByVal dy As Single) As GpStatus
    m_uLastStatus = GdipSetMatrixElements(m_lngMatrix, m11, m12, m21, m22, dx, dy)
    SetElements = m_uLastStatus
End Function

' updates this matrix with the product of itself and a shearing matrix.
Public Function Shear(ByVal shearX As Single, ByVal shearY As Single, _
                      Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipShearMatrix(m_lngMatrix, shearX, shearY, uOrder)
    Shear = m_uLastStatus
End Function

' multiplies each point in an array by this matrix. Each point is treated as a row matrix.
' The multiplication is performed with the row matrix on the left and this matrix on the right.
Public Function TransformPointsF(ByRef pts() As cPointF, Optional ByVal lCount As Long = 1) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTF
    
    Call ConvertPointFToType(pts, uP)
    m_uLastStatus = GdipTransformMatrixPoints(m_lngMatrix, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformPointsF = m_uLastStatus
End Function

' multiplies each point in an array by this matrix. Each point is treated as a row matrix.
' The multiplication is performed with the row matrix on the left and this matrix on the right.
Public Function TransformPointsL(ByRef pts() As cPoint, Optional ByVal lCount As Long = 1) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTL
    
    Call ConvertPointLToType(pts, uP)
    m_uLastStatus = GdipTransformMatrixPointsI(m_lngMatrix, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformPointsL = m_uLastStatus
End Function

' multiplies each vector in an array by this matrix. The translation elements of this matrix
' (third row) are ignored. Each vector is treated as a row matrix. The multiplication is
' performed with the row matrix on the left and this matrix on the right
Public Function TransformVectorsF(ByRef pts() As cPointF, Optional ByVal lCount As Long = 1) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTF
    
    Call ConvertPointFToType(pts, uP)
    m_uLastStatus = GdipVectorTransformMatrixPoints(m_lngMatrix, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformVectorsF = m_uLastStatus
End Function

' multiplies each vector in an array by this matrix. The translation elements of this matrix
' (third row) are ignored. Each vector is treated as a row matrix. The multiplication is
' performed with the row matrix on the left and this matrix on the right
Public Function TransformVectorsL(ByRef pts() As cPoint, Optional ByVal lCount As Long = 1) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTL
    
    Call ConvertPointLToType(pts, uP)
    m_uLastStatus = GdipVectorTransformMatrixPointsI(m_lngMatrix, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformVectorsL = m_uLastStatus
End Function

' updates this matrix with the product of itself and a translation matrix.
Public Function Translate(ByVal offsetX As Single, ByVal offsetY As Single, _
                          Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipTranslateMatrix(m_lngMatrix, offsetX, offsetY, uOrder)
    Translate = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposeMatrix
    m_uLastStatus = GdipCreateMatrix(m_lngMatrix)
End Sub

Private Sub Class_Terminate()
    Call DisposeMatrix
End Sub
