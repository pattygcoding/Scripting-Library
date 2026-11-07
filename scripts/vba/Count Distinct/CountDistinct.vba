Option Explicit

' ===========================================================================
' CountDistinct  -  Excel (VBA)
' Counts the distinct, non-blank values in a column.
'
' Parameters
'   column   Column letter to scan, e.g. "A".
'   sheet    Sheet to read: a name, a Worksheet, or omitted (active).
'
' Returns
'   The number of distinct values (a plain message if the sheet or column is
'   not valid).
'
' Worksheet usage
'   =CountDistinct("A")
'   =CountDistinct("C", "Sheet2")
' ===========================================================================
Public Function CountDistinct(ByVal column As String, Optional ByVal sheet As Variant) As Variant
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        CountDistinct = "Sheet not found"
        Exit Function
    End If

    Dim col As Long
    col = ColumnLetterToNumber(column)
    If col = 0 Then
        CountDistinct = "Invalid column letter"
        Exit Function
    End If

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, col).End(xlUp).Row

    Dim seen As Object
    Set seen = CreateObject("Scripting.Dictionary")

    Dim r As Long, key As String
    For r = 1 To lastRow
        key = CellText(ws.Cells(r, col).Value)
        If Len(key) > 0 And Not seen.Exists(key) Then
            seen.Add key, True
        End If
    Next r

    CountDistinct = seen.Count
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

Private Function ColumnLetterToNumber(ByVal letter As String) As Long
    Dim text As String, i As Long, code As Long, total As Long
    text = UCase$(Trim$(letter))
    For i = 1 To Len(text)
        code = Asc(Mid$(text, i, 1))
        If code < 65 Or code > 90 Then Exit Function
        total = total * 26 + (code - 64)
    Next i
    ColumnLetterToNumber = total
End Function

Private Function CellText(ByVal value As Variant) As String
    If IsError(value) Or IsEmpty(value) Or IsNull(value) Then
        CellText = ""
    Else
        CellText = CStr(value)
    End If
End Function
