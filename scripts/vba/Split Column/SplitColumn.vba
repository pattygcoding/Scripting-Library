Option Explicit

' ===========================================================================
' SplitColumn  -  Excel (VBA)
' Splits one column on a delimiter and writes the parts into the columns to
' its right.
'
' Parameters
'   column      Column letter to split, e.g. "A".
'   delimiter   Text to split on. Default ",".
'   sheet       Sheet to edit: a name, a Worksheet, or omitted (active).
'
' Run it from the Macro dialog (Alt + F8) or a button.
' ===========================================================================
Public Sub SplitColumn(Optional ByVal column As String = "A", _
                       Optional ByVal delimiter As String = ",", _
                       Optional ByVal sheet As Variant)
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        MsgBox "Sheet not found", vbExclamation
        Exit Sub
    End If

    Dim col As Long
    col = ColumnLetterToNumber(column)
    If col = 0 Then
        MsgBox "Invalid column letter: " & column, vbExclamation
        Exit Sub
    End If

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, col).End(xlUp).Row
    If lastRow < 1 Then Exit Sub

    Dim values As Variant
    values = ColumnValues(ws, col, lastRow)

    ' How many parts does the widest cell produce?
    Dim parts() As String, maxParts As Long, r As Long
    For r = 1 To lastRow
        parts = Split(values(r), delimiter)
        If UBound(parts) + 1 > maxParts Then maxParts = UBound(parts) + 1
    Next r
    If maxParts <= 1 Then
        MsgBox "Nothing to split", vbInformation
        Exit Sub
    End If

    Dim output() As Variant, c As Long, count As Long
    ReDim output(1 To lastRow, 1 To maxParts)
    For r = 1 To lastRow
        parts = Split(values(r), delimiter)
        count = UBound(parts) + 1
        For c = 1 To maxParts
            If c <= count Then
                output(r, c) = Trim$(parts(c - 1))
            Else
                output(r, c) = ""
            End If
        Next c
    Next r

    ws.Range(ws.Cells(1, col + 1), ws.Cells(lastRow, col + maxParts)).Value = output
    MsgBox maxParts & " column(s) written from " & UCase$(column), vbInformation
End Sub

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

' A column's cells as a 1-based string array (handles the one-row case).
Private Function ColumnValues(ByVal ws As Worksheet, ByVal col As Long, ByVal lastRow As Long) As Variant
    Dim raw As Variant, result() As String, r As Long
    raw = ws.Range(ws.Cells(1, col), ws.Cells(lastRow, col)).Value
    ReDim result(1 To lastRow)
    If IsArray(raw) Then
        For r = 1 To lastRow
            result(r) = CellText(raw(r, 1))
        Next r
    Else
        result(1) = CellText(raw)
    End If
    ColumnValues = result
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
