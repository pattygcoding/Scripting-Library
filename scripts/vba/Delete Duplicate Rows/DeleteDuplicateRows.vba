Option Explicit

' ===========================================================================
' DeleteDuplicateRows  -  Excel (VBA)
' Deletes rows whose key columns repeat an earlier row, keeping the first
' occurrence and removing the later duplicates.
'
' Parameters
'   keyColumns   Comma-separated column letters that make up the key,
'                e.g. "A" or "A,B,C".  Default "A".
'   sheet        Sheet to edit: a name, a Worksheet, or omitted (active).
'   headerRows   Number of header rows to leave untouched.  Default 1.
'
' Run it from the Macro dialog (Alt + F8) or a button; it edits the sheet
' in place and reports how many rows it removed.
' ===========================================================================
Public Sub DeleteDuplicateRows(Optional ByVal keyColumns As String = "A", _
                               Optional ByVal sheet As Variant, _
                               Optional ByVal headerRows As Long = 1)
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then Exit Sub

    Dim cols As Collection
    Set cols = ParseColumns(keyColumns)
    If cols.Count = 0 Then Exit Sub

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, cols(1)).End(xlUp).Row
    If lastRow <= headerRows Then Exit Sub

    Dim seen As Object, duplicates As Object
    Set seen = CreateObject("Scripting.Dictionary")
    Set duplicates = CreateObject("Scripting.Dictionary")

    Dim r As Long, key As String
    For r = headerRows + 1 To lastRow
        key = RowKey(ws, r, cols)
        If Len(key) > 0 Then
            If seen.Exists(key) Then
                duplicates(r) = True
            Else
                seen.Add key, True
            End If
        End If
    Next r

    ' Delete from the bottom up so the row numbers above stay valid.
    For r = lastRow To headerRows + 1 Step -1
        If duplicates.Exists(r) Then ws.Rows(r).Delete
    Next r
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

' "A,B,C" -> the collection {1, 2, 3}, skipping anything that is not a letter.
Private Function ParseColumns(ByVal text As String) As Collection
    Dim result As Collection, parts() As String, i As Long, num As Long
    Set result = New Collection
    parts = Split(text, ",")
    For i = 0 To UBound(parts)
        num = ColumnLetterToNumber(parts(i))
        If num > 0 Then result.Add num
    Next i
    Set ParseColumns = result
End Function

' The composite key for one row, its key cells joined with "|".
Private Function RowKey(ByVal ws As Worksheet, ByVal r As Long, ByVal cols As Collection) As String
    Dim parts() As String, i As Long
    ReDim parts(1 To cols.Count)
    For i = 1 To cols.Count
        parts(i) = CellText(ws.Cells(r, cols(i)).Value)
    Next i
    RowKey = Join(parts, "|")
End Function

Private Function CellText(ByVal value As Variant) As String
    If IsError(value) Or IsEmpty(value) Or IsNull(value) Then
        CellText = ""
    Else
        CellText = CStr(value)
    End If
End Function
