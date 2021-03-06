Sub wall_streetMethod1()
 'Solving challange with interations  
 Dim lastRow, lastColumn, IntCount  As Integer
 Dim headers(0 To 3), TickerName As String
 Dim TickerVol, TickerYearChange, TickerPercentChange, TickerRowLast, TickerRowFirst, gi, gd, gv As Double
 Dim YearChangeRange, PercentChangeRange, VolRange, GreatestIncrease, GreatestDecrease, GreatestVol as Range
    
For Each ws In Worksheets
    
ws.Activate

lastRow = Cells(Rows.Count, 1).End(xlUp).Row
lastColumn = Cells(1, Columns.Count).End(xlToLeft).Column
CurrentName = ActiveSheet.Name

'Sort by Ticker and by Date    
Range("a1").CurrentRegion.Sort key1:=Range("a1"), Order1:=xlAscending, key2:=Range("b1"), Order2:=xlAscending, Header:=xlYes
    
    'Summary table structurer
    
    'Summary Table Headers
    headers(0) = "Ticker"
    headers(1) = "Yearly Change"
    headers(2) = "Percent Change"
    headers(3) = "Total Stock Volume"
    
    For i = 0 To 3
        Cells(1, lastColumn + (2 + i)).Value = headers(i)
    Next i
    
    'Summary table information
    
    IntCount = 2 '// Interation counter
    For j = 2 To lastRow
        
        If Cells(j, 1).Value = Cells(j + 1, 1).Value Then
            TickerVol = TickerVol + Cells(j, 7).Value
            
        Else
           TickerName = Cells(j, 1).Value
           TickerVol = TickerVol + Cells(j, 7).Value
                  
            If IntCount = 2 Then           
                TickerRowFirst = 2
                TickerRowLast = j
            Else                            
                TickerRowFirst = TickerRowLast + 1
                TickerRowLast = j
            End If
           'Stimate the Yearly change from opening price at the beginning of a given year to the closing price at the end of that year
           TickerYearChange = Cells(TickerRowLast, 6).Value - Cells(TickerRowFirst, 3).Value
           'Stimate the percent change from opening price at the beginning of a given year to the closing price at the end of that year.
            If Cells(TickerRowFirst, 3).Value <> 0 Then            
                TickerPercentChange = Cells(TickerRowLast, 6).Value / Cells(TickerRowFirst, 3).Value - 1
                   
            Else            
                TickerPercentChange = 0
           
            End If
              
           Cells(IntCount, lastColumn + 2).Value = TickerName
           Cells(IntCount, lastColumn + 3).Value = TickerYearChange
           Cells(IntCount, lastColumn + 4).Value = TickerPercentChange
           Cells(IntCount, lastColumn + 5).Value = TickerVol
           TickerVol = 0
           IntCount = IntCount + 1
            
        End If
      
    Next j
        
    Set YearChangeRange = Range(Cells(2, lastColumn + 3), Cells(IntCount-1, lastColumn + 3))
    Set PercentChangeRange = Range(Cells(2, lastColumn + 4), Cells(IntCount-1, lastColumn + 4))
    Set VolRange = Range(Cells(2, lastColumn + 5), Cells(IntCount-1, lastColumn + 5))
    
    'Formating summary table
    
    YearChangeRange.Select
        With Selection
            .NumberFormat = "0.00"
        End With
        Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, Formula1:="=0"
        Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
        With Selection.FormatConditions(1).Interior
            .PatternColorIndex = xlAutomatic
            .Color = 5287936
            .TintAndShade = 0
        End With
        Selection.FormatConditions(1).StopIfTrue = False
        Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, Formula1:="=0"
        Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
        With Selection.FormatConditions(1).Interior
            .PatternColorIndex = xlAutomatic
            .Color = 255
            .TintAndShade = 0
        End With
        Selection.FormatConditions(1).StopIfTrue = False
    
    PercentChangeRange.Select
       With Selection
            .NumberFormat = "0.00%"
       End With
    
    VolRange.Select
       With Selection
            .NumberFormat = "#,##0"
       End With
    
    'Greaters Values
   
    Cells(1, lastColumn + 9).Value = "Ticker"
    Cells(1, lastColumn + 10).Value = "Value"
    Cells(2, lastColumn + 8).Value = "Greatest % increase"
    Cells(3, lastColumn + 8).Value = "Greatest % decrease"
    Cells(4, lastColumn + 8).Value = "Greatest total volume"
    Cells(4, lastColumn + 8).Columns.EntireColumn.AutoFit
        
    Set GreatestIncrease = Cells(2, lastColumn + 10)
    Set GreatestDecrease = Cells(3, lastColumn + 10)
    Set GreatestVol = Cells(4, lastColumn + 10)

    'Finding the greaters valuer in summary table         
    
    For Each Cell In PercentChangeRange
        If Cell.Value > gi Then            
            gi = Cell.Value

        End If
    Next Cell
    GreatestIncrease.Value = gi

    For k=2 to IntCount-1
        If Cells(k, lastColumn + 4).Value = GreatestIncrease.Value Then
            Cells(2, lastColumn + 9).Value = Cells(k, lastColumn + 2).Value
            Exit For
        End If
    Next k

    For Each Cell In PercentChangeRange
        If Cell.Value < gd Then            
            gd = Cell.Value

        End If
    Next Cell
    GreatestDecrease.Value = gd

    For m=2 to IntCount-1
        If Cells(m, lastColumn + 4).Value = GreatestDecrease.Value Then
            Cells(3, lastColumn + 9).Value = Cells(m, lastColumn + 2).Value
            Exit For
        End If
    Next m    
   
    For Each Cell In VolRange
        If Cell.Value>gv Then            
            gv = Cell.Value

        End If
    Next Cell
    GreatestVol.Value = gv

    For n=2 to IntCount-1
        If Cells(n, lastColumn + 5).Value = GreatestVol.Value Then
            Cells(4, lastColumn + 9).Value = Cells(n, lastColumn + 2).Value
            Exit For
        End If
    Next n

    gi = 0 'Clean value for next sheet
    gd = 0 'Clean value for next sheet
    gv = 0 'Clean value for next sheet

   GreatestIncrease.Select
    With Selection
    .NumberFormat = "0.00%"
    End With
    
    GreatestDecrease.Select
    With Selection
    .NumberFormat = "0.00%"
    End With
    
    GreatestVol.Select
    With Selection
    .NumberFormat = "#,##0"
    End With
    
Next ws
    
End Sub