Option Explicit

' ===========================================================================
' BuildInsert  -  Excel (VBA)
' Builds one INSERT INTO statement per data row from a header row and the rows
' below it.
'
' Parameters
'   tableName   Target table, e.g. "dbo.Users".
'   headerRow   Row holding the column names.
'   firstRow    First data row.
'   lastRow     Last data row.  0 or omitted means "to the end of the column".
'   sheet       Sheet to read: a name, a Worksheet, or omitted (active).
'
' Returns
'   One "INSERT INTO [table] ([cols]) VALUES (...);" statement per row.
'   Text is single-quoted (internal quotes doubled); blank cells become NULL.
'
' Worksheet usage
'   =BuildInsert("dbo.Users", 1, 2)
'   =BuildInsert("dbo.Users", 1, 2, 10)
' ===========================================================================
Public Function BuildInsert(ByVal tableName As String, ByVal headerRow As Long, ByVal firstRow As Long, _
                            Optional ByVal lastRow As Long = 0, Optional ByVal sheet As Variant) As String
    Dim ws As Worksheet
    Set ws = ResolveSheet(sheet)
    If ws Is Nothing Then
        BuildInsert = "Sheet not found"
        Exit Function
    End If

    Dim lastCol As Long
    lastCol = ws.Cells(headerRow, ws.Columns.Count).End(xlToLeft).Column
    If lastCol = 0 Then
        BuildInsert = "No columns found"
        Exit Function
    End If

    If lastRow <= 0 Then
        lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    End If
    If lastRow < firstRow Then
        BuildInsert = "No data rows"
        Exit Function
    End If

    Dim columns As String, c As Long
    For c = 1 To lastCol
        If c > 1 Then columns = columns & ", "
        columns = columns & "[" & CellText(ws.Cells(headerRow, c).Value) & "]"
    Next c

    Dim report As String, r As Long, values As String
    For r = firstRow To lastRow
        values = ""
        For c = 1 To lastCol
            If c > 1 Then values = values & ", "
            values = values & SqlLiteral(ws.Cells(r, c).Value)
        Next c
        report = report & "INSERT INTO [" & tableName & "] (" & columns & ") VALUES (" & values & ");" & vbLf
    Next r

    BuildInsert = ReportOr(report, "No data rows")
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

' A cell value rendered as a SQL literal: numbers bare, text quoted, blanks NULL.
Private Function SqlLiteral(ByVal value As Variant) As String
    If IsError(value) Or IsEmpty(value) Or IsNull(value) Then
        SqlLiteral = "NULL"
        Exit Function
    End If

    Dim text As String
    text = CStr(value)
    If Len(Trim$(text)) = 0 Then
        SqlLiteral = "NULL"
    ElseIf VarType(value) = vbDate Then
        SqlLiteral = "'" & Format$(value, "yyyy-mm-dd hh:nn:ss") & "'"
    ElseIf VarType(value) <> vbString And IsNumeric(text) Then
        SqlLiteral = text
    Else
        SqlLiteral = "'" & Replace(text, "'", "''") & "'"
    End If
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
