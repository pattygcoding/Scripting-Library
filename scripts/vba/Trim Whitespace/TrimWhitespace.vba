Option Explicit

' ===========================================================================
' TrimWhitespace  -  Excel (VBA)
' Trims the leading and trailing spaces from every cell in a range, in place,
' and reports how many cells changed.
'
' Parameters
'   address   A range ("A1:C50"), a whole column ("A"), or a name.
'   sheet     Sheet to edit: a name, a Worksheet, or omitted (active).
'
' Run it from the Macro dialog (Alt + F8) or a button.
' ===========================================================================
Public Sub TrimWhitespace(Optional ByVal address As String = "A", Optional ByVal sheet As Variant)
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        MsgBox "Sheet not found", vbExclamation
        Exit Sub
    End If

    Dim target As Range
    Set target = ResolveRange(ws, address)
    If target Is Nothing Then
        MsgBox "Invalid range: " & address, vbExclamation
        Exit Sub
    End If

    Dim previous As Boolean
    previous = Application.ScreenUpdating
    Application.ScreenUpdating = False

    Dim cell As Range, text As String, trimmed As String, changed As Long
    For Each cell In target.Cells
        text = CellText(cell.Value)
        If Len(text) > 0 Then
            trimmed = Trim$(text)
            If trimmed <> text Then
                cell.Value = trimmed
                changed = changed + 1
            End If
        End If
    Next cell

    Application.ScreenUpdating = previous
    MsgBox changed & " cell(s) trimmed", vbInformation
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

' A range address, or a bare column letter expanded to that column's used rows.
Private Function ResolveRange(ByVal ws As Worksheet, ByVal address As String) As Range
    Dim text As String
    text = Trim$(address)
    If Len(text) = 0 Then Exit Function

    If Len(text) <= 3 Then
        Dim col As Long
        col = ColumnLetterToNumber(text)
        If col > 0 Then
            Dim lastRow As Long
            lastRow = ws.Cells(ws.Rows.Count, col).End(xlUp).Row
            If lastRow < 1 Then lastRow = 1
            Set ResolveRange = ws.Range(ws.Cells(1, col), ws.Cells(lastRow, col))
            Exit Function
        End If
    End If

    On Error Resume Next
    Set ResolveRange = ws.Range(text)
    On Error GoTo 0
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
