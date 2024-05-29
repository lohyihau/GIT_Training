Attribute VB_Name = "VBT_CheckVOHVOL"
Option Explicit

Public Function B4CharP50VOHVOL(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim VOHValue As Double
    Dim VOLValue As Double
    Dim P50VohLevel As Double
    Dim P50VolLevel As Double
    Dim site As Variant
    
    Call TheExec.Datalog.WriteComment(" ")
    Call TheExec.Datalog.WriteComment("Before Characterization")
    Call TheExec.Datalog.WriteComment("======================")
    
    For Each site In TheExec.Sites
              
        VOHValue = TheExec.Specs.DC("VOH_P50").CurrentValue
        VOLValue = TheExec.Specs.DC("VOL_P50").CurrentValue
                
        P50VohLevel = TheHdw.Digital.Pins("P50").Levels.Value(chVoh)
        P50VolLevel = TheHdw.Digital.Pins("P50").Levels.Value(chVol)
                               
        Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH DC Spec = " & VOHValue & " V")
        Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOL DC Spec = " & VOLValue & " V")
          
        'Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH Level = " & P50VohLevel & " V")
        'Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH Level = " & P50VolLevel & " V")
          
    Next site

      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


Public Function AfCharP50VOHVOL(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim VOHValue As Double
    Dim VOLValue As Double
    Dim P50VohLevel As Double
    Dim P50VolLevel As Double
    Dim site As Variant
    
    Call TheExec.Datalog.WriteComment(" ")
    Call TheExec.Datalog.WriteComment("After Characterization")
    Call TheExec.Datalog.WriteComment("======================")
    
    For Each site In TheExec.Sites
              
        VOHValue = TheExec.Specs.DC("VOH_P50").CurrentValue
        VOLValue = TheExec.Specs.DC("VOL_P50").CurrentValue
                
        P50VohLevel = TheHdw.Digital.Pins("P50").Levels.Value(chVoh)
        P50VolLevel = TheHdw.Digital.Pins("P50").Levels.Value(chVol)
                               
        Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH DC Spec = " & VOHValue & " V")
        Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOL DC Spec = " & VOLValue & " V")
          
        'Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH Level = " & P50VohLevel & " V")
        'Call TheExec.Datalog.WriteComment("Site " & CStr(site) & " P50 VOH Level = " & P50VolLevel & " V")
          
    Next site

    Call TheExec.Datalog.WriteComment(" ")
      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


