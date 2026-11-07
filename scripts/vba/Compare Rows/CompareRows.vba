Option Explicit

' ===========================================================================
' CompareRows  -  Excel (VBA)
' Compares two rows of a worksheet and returns the columns that differ.
'
' Parameters
'   row1, row2        Row numbers to compare, e.g. 2 and 3.
'   sheet             Sheet to read: a name, a Worksheet, or omitted (active).
'   includeTimestamps FALSE (default) skips columns whose two cells both look
'                     like SQL Server timestamps; TRUE compares every column.
'
' Returns
'   A newline-separated report ("Column C: v1 vs v2"), or "No differences".
'
' Worksheet usage
'   =CompareRows(2, 3)
'   =CompareRows(2, 3, "Sheet2")
'   =CompareRows(2, 3, , TRUE)
' ===========================================================================
Public Function CompareRows(ByVal row1 As Long, ByVal row2 As Long, _
                            Optional ByVal sheet As Variant, _
                            Optional ByVal includeTimestamps As Boolean = False) As String
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        CompareRows = "Sheet not found"
        Exit Function
    End If

    Dim lastCol As Long
    lastCol = WorksheetLastColumn(ws, row1, row2)

    Dim report As String
    Dim c As Long, a As Variant, b As Variant
    For c = 1 To lastCol
        a = ws.Cells(row1, c).Value
        b = ws.Cells(row2, c).Value
        If includeTimestamps Or Not (IsTimestamp(a) And IsTimestamp(b)) Then
            If CellText(a) <> CellText(b) Then
                report = report & "Column " & ColumnNumberToLetter(c) & ": " & CellText(a) & " vs " & CellText(b) & vbLf
            End If
        End If
    Next c

    CompareRows = ReportOrNoDifferences(report)
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

' 1 -> "A", 28 -> "AB".
Private Function ColumnNumberToLetter(ByVal number As Long) As String
    Dim value As Long, remainder As Long, letter As String
    value = number
    Do While value > 0
        remainder = (value - 1) Mod 26
        letter = Chr$(65 + remainder) & letter
        value = (value - 1) \ 26
    Loop
    ColumnNumberToLetter = letter
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
        ReportOrNoDifferences = Left$(report, Len(report) - 1)
    End If
End Function
