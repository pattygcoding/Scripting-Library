Sub DeleteDuplicatePairsInAandH()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    Dim pairDict As Object
    Dim key As String
    Set ws = ActiveSheet
    Set pairDict = CreateObject("Scripting.Dictionary")

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    For i = lastRow To 2 Step -1
        If IsNumeric(ws.Cells(i, "A").Value) And IsNumeric(ws.Cells(i, "B").Value) Then
            key = ws.Cells(i, "A").Value & "|" & ws.Cells(i, "B").Value
            If pairDict.exists(key) Then
                ws.Rows(i).Delete
            Else
                pairDict.Add key, True
            End If
        End If
    Next i
End Sub
