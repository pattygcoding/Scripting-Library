Option Explicit

' ===========================================================================
' FindDuplicates  -  Excel (VBA)
' Lists the values that appear more than once in a column, with the rows each
' one is on.
'
' Parameters
'   column   Column letter to scan, e.g. "A".
'   sheet    Sheet to read: a name, a Worksheet, or omitted (active).
'
' Returns
'   A newline-separated report ("alice (rows 3, 7, 9)"), or "No duplicates".
'
' Worksheet usage
'   =FindDuplicates("A")
'   =FindDuplicates("C", "Sheet2")
' ===========================================================================
Public Function FindDuplicates(ByVal column As String, Optional ByVal sheet As Variant) As String
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        FindDuplicates = "Sheet not found"
        Exit Function
    End If

    Dim col As Long
    col = ColumnLetterToNumber(column)
    If col = 0 Then
        FindDuplicates = "Invalid column letter"
        Exit Function
    End If

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, col).End(xlUp).Row

    Dim rowsByValue As Object
    Set rowsByValue = CreateObject("Scripting.Dictionary")

    Dim r As Long, key As String
    For r = 1 To lastRow
        key = CellText(ws.Cells(r, col).Value)
        If Len(key) > 0 Then
            If Not rowsByValue.Exists(key) Then rowsByValue.Add key, New Collection
            rowsByValue(key).Add r
        End If
    Next r

    Dim report As String, value As Variant, rowList As Collection, i As Long, nums As String
    For Each value In rowsByValue.Keys
        Set rowList = rowsByValue(value)
        If rowList.Count > 1 Then
            nums = ""
            For i = 1 To rowList.Count
                If i > 1 Then nums = nums & ", "
                nums = nums & rowList(i)
            Next i
            report = report & value & " (rows " & nums & ")" & vbLf
        End If
    Next value

    FindDuplicates = ReportOr(report, "No duplicates")
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

Private Function ReportOr(ByVal report As String, ByVal fallback As String) As String
    If Len(report) = 0 Then
        ReportOr = fallback
    Else
        ReportOr = Left$(report, Len(report) - 1)
    End If
End Function
