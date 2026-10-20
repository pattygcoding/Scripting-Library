Public Function CompareColumns(column1 As String, column2 As String, Optional sheet As Worksheet, Optional includeTimestamps As Boolean = False) As String
    ' Set default sheet to the active sheet if not provided
    If sheet Is Nothing Then Set sheet = ActiveSheet
    
    If sheet Is Nothing Then
        CompareColumns = "Sheet not found"
        Exit Function
    End If
    
    ' Convert column letters to numbers
    Dim colNum1 As Long, colNum2 As Long
    colNum1 = LetterToColumn(column1)
    colNum2 = LetterToColumn(column2)
    
    ' Get the last row with data
    Dim lastRow As Long
    lastRow = sheet.Cells(sheet.Rows.Count, colNum1).End(xlUp).Row
    
    ' Get the data from the specified columns
    Dim columnData1 As Variant, columnData2 As Variant
    columnData1 = sheet.Range(sheet.Cells(1, colNum1), sheet.Cells(lastRow, colNum1)).Value
    columnData2 = sheet.Range(sheet.Cells(1, colNum2), sheet.Cells(lastRow, colNum2)).Value
    
    Dim differences As String
    differences = ""
    
    Dim i As Long
    For i = 1 To lastRow
        If Not includeTimestamps Then
            If IsTimestamp(columnData1(i, 1)) And IsTimestamp(columnData2(i, 1)) Then
                ' Skip comparison if both are timestamps and includeTimestamps is FALSE
                GoTo NextRow
            End If
        Else
            If Not IsTimestamp(columnData1(i, 1)) And Not IsTimestamp(columnData2(i, 1)) Then
                ' Skip comparison if neither are timestamps and includeTimestamps is TRUE
                GoTo NextRow
            End If
        End If
        
        If CStr(columnData1(i, 1)) <> CStr(columnData2(i, 1)) Then
            differences = differences & "Row " & i & ": " & columnData1(i, 1) & " vs " & columnData2(i, 1) & vbCrLf
        End If
        
NextRow:
    Next i
    
    If differences = "" Then
        CompareColumns = "No differences"
    Else
        CompareColumns = differences
    End If
End Function

' Function to convert column letter to number
Function LetterToColumn(letter As String) As Long
    Dim i As Long, column As Long
    column = 0
    For i = 1 To Len(letter)
        column = column * 26 + (Asc(UCase(Mid(letter, i, 1))) - Asc("A") + 1)
    Next i
    LetterToColumn = column
End Function

' Function to check if a value is a timestamp
Function IsTimestamp(value As Variant) As Boolean
    Dim timestampPattern As String
    timestampPattern = "^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$"
    
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    regex.Pattern = timestampPattern
    regex.IgnoreCase = True
    regex.Global = False
    
    IsTimestamp = regex.Test(CStr(value))
End Function
