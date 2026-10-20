Function CompareRows(row1 As Long, row2 As Long, Optional includeTimestamps As Boolean = False) As String
    Dim ws As Worksheet
    Set ws = ActiveSheet

    Dim rowData1 As Variant
    Dim rowData2 As Variant
    Dim differences As Collection
    Set differences = New Collection
    
    ' Get the data for the two rows
    rowData1 = ws.Rows(row1).Value
    rowData2 = ws.Rows(row2).Value

    Dim i As Long
    For i = 1 To UBound(rowData1, 2)
        If Not includeTimestamps And IsTimestamp(rowData1(1, i)) And IsTimestamp(rowData2(1, i)) Then
            ' Skip comparison if both are timestamps and includeTimestamps is FALSE
            GoTo SkipComparison
        ElseIf includeTimestamps And Not IsTimestamp(rowData1(1, i)) And Not IsTimestamp(rowData2(1, i)) Then
            ' Skip comparison if neither are timestamps and includeTimestamps is TRUE
            GoTo SkipComparison
        End If
        
        If rowData1(1, i) <> rowData2(1, i) Then
            differences.Add "Column " & Split(ws.Cells(1, i).Address, "$")(1) & ": " & rowData1(1, i) & " vs " & rowData2(1, i)
        End If
SkipComparison:
    Next i

    If differences.Count = 0 Then
        CompareRows = "No differences"
    Else
        Dim result As String
        result = ""
        Dim diff As Variant
        For Each diff In differences
            result = result & diff & vbNewLine
        Next diff
        CompareRows = result
    End If
End Function

Function IsTimestamp(value As Variant) As Boolean
    On Error Resume Next
    IsTimestamp = IsDate(value)
    On Error GoTo 0
End Function
