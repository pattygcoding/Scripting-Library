Option Explicit

' ===========================================================================
' CompareSheets  -  Excel (VBA)
' Compares two sheets cell by cell over their shared top-left region and
' returns the cells that differ.
'
' Parameters
'   sheet1, sheet2      Names of the two sheets to compare.
'   includeTimestamps   FALSE (default) skips cells whose two values both look
'                       like SQL Server timestamps; TRUE compares every cell.
'
' Returns
'   A newline-separated report ("Cell C4: v1 vs v2"), or "No differences".
'
' Worksheet usage
'   =CompareSheets("Sheet1", "Sheet2")
'   =CompareSheets("Before", "After", TRUE)
' ===========================================================================
Public Function CompareSheets(ByVal sheet1 As String, ByVal sheet2 As String, _
                              Optional ByVal includeTimestamps As Boolean = False) As String
    Dim ws1 As Worksheet, ws2 As Worksheet
    Set ws1 = ResolveSheet(sheet1)
    Set ws2 = ResolveSheet(sheet2)
    If ws1 Is Nothing Or ws2 Is Nothing Then
        CompareSheets = "Sheet not found"
        Exit Function
    End If

    Dim lastRow As Long, lastCol As Long
    lastRow = Smaller(UsedLastRow(ws1), UsedLastRow(ws2))
    lastCol = Smaller(UsedLastColumn(ws1), UsedLastColumn(ws2))

    Dim report As String
    Dim r As Long, c As Long, a As Variant, b As Variant
    For r = 1 To lastRow
        For c = 1 To lastCol
            a = ws1.Cells(r, c).Value
            b = ws2.Cells(r, c).Value
            If includeTimestamps Or Not (IsTimestamp(a) And IsTimestamp(b)) Then
                If CellText(a) <> CellText(b) Then
                    report = report & "Cell " & ColumnNumberToLetter(c) & r & ": " & CellText(a) & " vs " & CellText(b) & vbLf
                End If
            End If
        Next c
    Next r

    CompareSheets = ReportOrNoDifferences(report)
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

Private Function UsedLastRow(ByVal ws As Worksheet) As Long
    UsedLastRow = ws.UsedRange.Row + ws.UsedRange.Rows.Count - 1
End Function

Private Function UsedLastColumn(ByVal ws As Worksheet) As Long
    UsedLastColumn = ws.UsedRange.Column + ws.UsedRange.Columns.Count - 1
End Function

Private Function Smaller(ByVal a As Long, ByVal b As Long) As Long
    Smaller = IIf(a < b, a, b)
End Function

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
