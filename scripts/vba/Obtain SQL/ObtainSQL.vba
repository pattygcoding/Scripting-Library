Function ObtainSQL(headerRow As Long, valueRow As Long, Optional sheet As Worksheet) As String
    ' If no sheet is provided, use the active sheet
    If sheet Is Nothing Then
        Set sheet = ActiveSheet
    End If

    Dim sqlParts As Collection
    Set sqlParts = New Collection
    
    ' Get the last column in the sheet
    Dim lastColumn As Long
    lastColumn = sheet.Cells(headerRow, sheet.Columns.Count).End(xlToLeft).Column
    
    ' Loop through the headers and values to build the SQL string
    Dim i As Long
    Dim header As String
    Dim value As String
    
    For i = 1 To lastColumn
        header = sheet.Cells(headerRow, i).Value
        value = sheet.Cells(valueRow, i).Value
        
        If value <> "" Then
            sqlParts.Add value & " as [" & header & "]"
        End If
    Next i
    
    ' Join the parts with a comma and newline
    Dim sqlString As String
    sqlString = Join(Application.Transpose(sqlParts.ToArray), ", " & vbNewLine)
    
    ObtainSQL = sqlString
End Function
