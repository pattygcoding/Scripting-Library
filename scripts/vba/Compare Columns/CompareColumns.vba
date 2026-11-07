Option Explicit

' ===========================================================================
' CompareColumns  -  Excel (VBA)
' Compares two columns of a worksheet and returns the rows that differ.
'
' Parameters
'   column1, column2  Column letters to compare, e.g. "A" and "B".
'   sheet             Sheet to read: a name, a Worksheet, or omitted (active).
'   includeTimestamps FALSE (default) skips rows whose two cells both look
'                     like SQL Server timestamps; TRUE compares every row.
'
' Returns
'   A newline-separated report ("Row 4: v1 vs v2"), or "No differences".
'
' Worksheet usage
'   =CompareColumns("B", "C")
'   =CompareColumns("B", "C", "Sheet2")
'   =CompareColumns("B", "C", , TRUE)
' ===========================================================================
Public Function CompareColumns(ByVal column1 As String, ByVal column2 As String, _
                               Optional ByVal sheet As Variant, _
                               Optional ByVal includeTimestamps As Boolean = False) As String
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        CompareColumns = "Sheet not found"
        Exit Function
    End If

    Dim col1 As Long, col2 As Long
    col1 = ColumnLetterToNumber(column1)
    col2 = ColumnLetterToNumber(column2)
    If col1 = 0 Or col2 = 0 Then
        CompareColumns = "Invalid column letter"
        Exit Function
    End If

    Dim lastRow As Long
    lastRow = WorksheetLastRow(ws, col1, col2)

    Dim report As String
    Dim r As Long, a As Variant, b As Variant
    For r = 1 To lastRow
        a = ws.Cells(r, col1).Value
        b = ws.Cells(r, col2).Value
        If includeTimestamps Or Not (IsTimestamp(a) And IsTimestamp(b)) Then
            If CellText(a) <> CellText(b) Then
                report = report & "Row " & r & ": " & CellText(a) & " vs " & CellText(b) & vbLf
            End If
        End If
    Next r

    CompareColumns = ReportOrNoDifferences(report)
End Function

' ---------------------------------------------------------------------------
' Helpers.  Private, so several of these scripts can live in one workbook
' without their helper names clashing.
' ---------------------------------------------------------------------------

' A sheet name, a Worksheet object, or nothing (the active sheet).
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

' "A" -> 1, "AB" -> 28.  Returns 0 for anything that is not letters.
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

' The last row that holds data in either of the two columns.
Private Function WorksheetLastRow(ByVal ws As Worksheet, ByVal col1 As Long, ByVal col2 As Long) As Long
    Dim r1 As Long, r2 As Long
    r1 = ws.Cells(ws.Rows.Count, col1).End(xlUp).Row
    r2 = ws.Cells(ws.Rows.Count, col2).End(xlUp).Row
    WorksheetLastRow = IIf(r1 > r2, r1, r2)
End Function

' True for a value shaped like a SQL Server "Mon Jan 01 2024 12:00:00 GMT+0000 (GMT+00:00)".
Private Function IsTimestamp(ByVal value As Variant) As Boolean
    Static pattern As Object
    If pattern Is Nothing Then
        Set pattern = CreateObject("VBScript.RegExp")
        pattern.Pattern = "^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$"
    End If
    IsTimestamp = pattern.Test(CellText(value))
End Function

' A cell value as text, with errors and blanks reading as "".
Private Function CellText(ByVal value As Variant) As String
    If IsError(value) Or IsEmpty(value) Or IsNull(value) Then
        CellText = ""
    Else
        CellText = CStr(value)
    End If
End Function

Private Function ReportOrNoDifferences(ByVal report As String) As String
    If Len(report) = 0 Then
        ReportOrNoDifferences = "No differences"
    Else
        ReportOrNoDifferences = Left$(report, Len(report) - 1)   ' drop the trailing newline
    End If
End Function
