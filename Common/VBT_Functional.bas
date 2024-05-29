Attribute VB_Name = "VBT_Functional"
Option Explicit


Public Function Function_test(PatternFile As Pattern, Init_HiPins As PinList)

    On Error GoTo errHandler

'  Apply HSD levels, Init States, Float Pins  and PowerSupply pin values
'  Connect all pins,load levels,load timings,no hot-switching
    TheHdw.Digital.ApplyLevelsTiming True, True, True, tlUnpowered, Init_HiPins.Value
       
'  Test pattern ti245_func. Set pass fail flag as Always report to datalog
'  and set it to not stop on first failure
    TheHdw.Patterns(PatternFile).test pfAlways, 0
        
      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function
