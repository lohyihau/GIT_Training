Attribute VB_Name = "VBT_FallTime"
Option Explicit

Public Function FallTime_test(PatternFile As Pattern, Init_HiPins As PinList)

    On Error GoTo errHandler

'  Apply HSD levels, Init States, Float Pins  and PowerSupply pin values
'  Connect all pins,load levels,load timings,no hot-switching
    TheHdw.Digital.ApplyLevelsTiming True, True, True, tlUnpowered, Init_HiPins.Value
           
    Dim VOHValue As Double
    Dim VOLValue As Double
    Dim P53VohLevel As Double
    Dim P53VolLevel As Double
    Dim site As Variant
    For Each site In TheExec.Sites
        
        
        VOHValue = TheExec.Specs.DC("VOH_P53").CurrentValue
        VOLValue = TheExec.Specs.DC("VOL_P53").CurrentValue
        
        TheHdw.Digital.Pins("P53").Levels.Value(chVoh) = VOHValue - (0.1 * (VOHValue - VOLValue))
        TheHdw.Digital.Pins("P53").Levels.Value(chVol) = VOLValue + (0.1 * (VOHValue - VOLValue))
        
        P53VohLevel = TheHdw.Digital.Pins("P53").Levels.Value(chVoh)
        P53VolLevel = TheHdw.Digital.Pins("P53").Levels.Value(chVol)
          
    Next site

        
'  Test pattern ti245_func. Set pass fail flag as Always report to datalog
'  and set it to not stop on first failure
    TheHdw.Patterns(PatternFile).test pfAlways, 0
        
      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


