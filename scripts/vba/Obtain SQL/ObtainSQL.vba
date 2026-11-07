Option Explicit

' ===========================================================================
' ObtainSQL  -  Excel (VBA)
' Builds the SELECT column list for a query out of a header row and a value
' row:  value1 as [Header1], value2 as [Header2], ...
'
' Parameters
'   headerRow   Row holding the column headers.
'   valueRow    Row holding the values to keep as literals.
'   sheet       Sheet to read: a name, a Worksheet, or omitted (active).
'
' Returns
'   The comma-and-newline separated column list (empty cells are skipped).
'
' Worksheet usage
'   =ObtainSQL(1, 2)
'   =ObtainSQL(1, 2, "Sheet2")
' ===========================================================================
Public Function ObtainSQL(ByVal headerRow As Long, ByVal valueRow As Long, _
                          Optional ByVal sheet As Variant) As String
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        ObtainSQL = "Sheet not found"
        Exit Function
    End If

    Dim lastCol As Long
    lastCol = WorksheetLastColumn(ws, headerRow, valueRow)

    Dim parts As Collection
    Set parts = New Collection

    Dim c As Long, header As String, value As String
    For c = 1 To lastCol
        header = CellText(ws.Cells(headerRow, c).Value)
        value = CellText(ws.Cells(valueRow, c).Value)
        If Len(value) > 0 Then
            parts.Add value & " as [" & header & "]"
        End If
    Next c

    ObtainSQL = JoinCollection(parts, "," & vbLf)
End Function

' ---------------------------------------------------------------------------
' Helpers (Private, so several of these scripts can share one workbook).
' ---------------------------------------------------------------------------

Private Function ResolveSheet(ByVal sheet As Variant) As Worksheet
    If IsObject(sheet) Then
        If TypeName(sheet) = "Worksheet" Then
            Set ResolveSheet = sheet
            Exit Function
        End If
    ElseIf VarType(sheet) = vbString Then
        On Error Resume Next
        Set ResolveSheet = ThisWorkbook.Worksheets(CStr(sheet))
        On Error GoTo 0
        Exit Function
    End If
    Set ResolveSheet = ActiveSheet
End Function

' The last column that holds data in either of the two rows.
Private Function WorksheetLastColumn(ByVal ws As Worksheet, ByVal row1 As Long, ByVal row2 As Long) As Long
    Dim c1 As Long, c2 As Long
    c1 = ws.Cells(row1, ws.Columns.Count).End(xlToLeft).Column
    c2 = ws.Cells(row2, ws.Columns.Count).End(xlToLeft).Column
    WorksheetLastColumn = IIf(c1 > c2, c1, c2)
End Function

Private Function CellText(ByVal value As Variant) As String
    If IsError(value) Or IsEmpty(value) Or IsNull(value) Then
        CellText = ""
    Else
        CellText = CStr(value)
    End If
End Function

Private Function JoinCollection(ByVal items As Collection, ByVal separator As String) As String
    Dim result As String, i As Long
    For i = 1 To items.Count
        If i > 1 Then result = result & separator
        result = result & items(i)
    Next i
    JoinCollection = result
End Function
