Attribute VB_Name = "VBT_Timing"
Option Explicit

Public Function RiseM(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

'Declaring a user variable as an Rta Data Object
Dim dataobj As New RtaDataObj
Dim logval As RtaLogVal

Dim SiteNum As Long

Dim StartPnt As Double
Dim EndPnt As Double
Dim Risetime As Double
Dim ResultStr As String

Dim TestNum As Long
Dim TestFlag As Long
Dim ParaFlag As Long
Dim PinName As String
Dim ChanNum As Long
Dim LowLimit As Double
Dim HighLimit As Double
Dim measVal As Double
Dim MeasUnits As Long
Dim ForceVal As Double
Dim ForceUnits As Long
    
Dim P50VohLevel As Double
Dim P50VolLevel As Double


'Setting the object to point to a particular characterization setup
Set dataobj = TheExec.DevChar.ActiveDataObject
Call dataobj.SetPt(0, 0, 0)

LowLimit = 0.000000001 '1ns
HighLimit = 0.0000001  '100ns

TestFlag = logTestFail
ParaFlag = parmLow
MeasUnits = unitTime

With dataobj
    For SiteNum = 0 To .SiteDim
        .site = SiteNum
        
 '       If dataobj.PtResult = RtaResult_RtaPass Then
            
            Call TheExec.Datalog.WriteComment(" ")
            Call TheExec.Datalog.WriteComment("================")
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum))
            Call TheExec.Datalog.WriteComment("================")
            
            P50VohLevel = Round(TheHdw.Digital.Pins("P50").Levels.Value(chVoh), 3)
            P50VolLevel = Round(TheHdw.Digital.Pins("P50").Levels.Value(chVol), 3)
                        
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum) & " P50 90% = " & P50VohLevel & " V")
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum) & " P50 10% = " & P50VolLevel & " V")
            
            If .MeasVals("rise_10pt") Like "*Stuck*" Then
                StartPnt = -0.000003
                Call TheExec.Datalog.WriteComment("The 10% point is " & .MeasVals("rise_10pt"))
            Else
                StartPnt = .MeasVals("rise_10pt")
                Call TheExec.Datalog.WriteComment("The 10% point is " & CStr(StartPnt * 1000000000#) & " nS")
            End If
            If .MeasVals("rise_90pt") Like "*Stuck*" Then
                EndPnt = 0.000003
                Call TheExec.Datalog.WriteComment("The 90% point is " & .MeasVals("rise_90pt"))
            Else
                EndPnt = .MeasVals("rise_90pt")
                Call TheExec.Datalog.WriteComment("The 90% point is " & CStr(EndPnt * 1000000000#) & " nS")
            End If
            
            Risetime = EndPnt - StartPnt
            
            If .MeasVals("rise_10pt") Like "*Stuck*" Or .MeasVals("rise_90pt") Like "*Stuck*" Then
                Call TheExec.Datalog.WriteComment("Unable to determine rise time for site " & CStr(SiteNum))
            Else
                Call TheExec.Datalog.WriteComment("Rise time for site " & CStr(SiteNum) & " = " & CStr(Risetime * 1000000000#) & " nS")
            End If
            
            measVal = Risetime
            If measVal < LowLimit Then
                TestFlag = logTestFail
                ParaFlag = parmLow
            ElseIf (measVal >= LowLimit And measVal <= HighLimit) Then
                TestFlag = logTestPass
                ParaFlag = parmPass
            Else
                TestFlag = logTestFail
                ParaFlag = parmHigh
            End If
            
            TestNum = TheExec.Sites(SiteNum).TestNumber
            
            ResultStr = "rise time = " & CStr(Risetime)
            PinName = "P50"
            Call TheExec.Datalog.WriteComment(" ")
            Call TheExec.Datalog.WriteParametricResult(SiteNum, TestNum, TestFlag, _
                ParaFlag, PinName, ChanNum, LowLimit, measVal, HighLimit, MeasUnits, _
                ForceVal, ForceUnits, 0)
'        End If
        
        Next SiteNum
End With
Call TheExec.Datalog.WriteComment(" ")
Call TheExec.Datalog.WriteComment("End rise time interpose function")
Call TheExec.Datalog.WriteComment("================================ ")
Call TheExec.Datalog.WriteComment(" ")
        
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


Public Function FallM(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

'Declaring a user variable as an Rta Data Object
Dim dataobj As New RtaDataObj
Dim logval As RtaLogVal

Dim SiteNum As Long

Dim StartPnt As Double
Dim EndPnt As Double
Dim Falltime As Double
Dim ResultStr As String

Dim TestNum As Long
Dim TestFlag As Long
Dim ParaFlag As Long
Dim PinName As String
Dim ChanNum As Long
Dim LowLimit As Double
Dim HighLimit As Double
Dim measVal As Double
Dim MeasUnits As Long
Dim ForceVal As Double
Dim ForceUnits As Long

Dim P53VohLevel As Double
Dim P53VolLevel As Double

'Setting the object to point to a particular characterization setup
Set dataobj = TheExec.DevChar.ActiveDataObject
Call dataobj.SetPt(0, 0, 0)

LowLimit = 0.000000001 '1ns
HighLimit = 0.00000015  '150ns

'theExec.Flow.testnumber

TestFlag = logTestFail
ParaFlag = parmLow
MeasUnits = unitTime

With dataobj
    For SiteNum = 0 To .SiteDim
        .site = SiteNum
        
        If dataobj.PtResult = RtaResult_RtaPass Then
            
            Call TheExec.Datalog.WriteComment(" ")
            Call TheExec.Datalog.WriteComment("================")
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum))
            Call TheExec.Datalog.WriteComment("================")
            
            P53VohLevel = Round(TheHdw.Digital.Pins("P53").Levels.Value(chVoh), 3)
            P53VolLevel = Round(TheHdw.Digital.Pins("P53").Levels.Value(chVol), 3)
            
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum) & " P53 90% = " & P53VohLevel & " V")
            Call TheExec.Datalog.WriteComment("Site " & CStr(SiteNum) & " P53 10% = " & P53VolLevel & " V")
            
             
            If .MeasVals("fall_90pt") Like "*Stuck*" Then
                StartPnt = -0.000003
                Call TheExec.Datalog.WriteComment("The 90% point is " & .MeasVals("fall_90pt"))
            Else
               StartPnt = .MeasVals("fall_90pt")
               Call TheExec.Datalog.WriteComment("The 90% point is " & CStr(StartPnt * 1000000000#) & " nS")
            End If
            
            If .MeasVals("fall_10pt") Like "*Stuck*" Then
                EndPnt = 0.000003
                Call TheExec.Datalog.WriteComment("The 10% point is " & .MeasVals("fall_10pt"))
            Else
               EndPnt = .MeasVals("fall_10pt")
               Call TheExec.Datalog.WriteComment("The 10% point is " & CStr(EndPnt * 1000000000#) & " nS")
            End If
            
            Falltime = EndPnt - StartPnt
            
            If .MeasVals("fall_10pt") Like "*Stuck*" Or .MeasVals("fall_90pt") Like "*Stuck*" Then
                Call TheExec.Datalog.WriteComment("Unable to determine fall time for site " & CStr(SiteNum))
            Else
                Call TheExec.Datalog.WriteComment("Fall time for site " & CStr(SiteNum) & " = " & CStr(Falltime * 1000000000#) & " nS")
            End If
            
            
            measVal = Falltime
            If measVal < LowLimit Then
                TestFlag = logTestFail
                ParaFlag = parmLow
            ElseIf (measVal >= LowLimit And measVal <= HighLimit) Then
                TestFlag = logTestPass
                ParaFlag = parmPass
            Else
                TestFlag = logTestFail
                ParaFlag = parmHigh
            End If
            
            TestNum = TheExec.Sites(SiteNum).TestNumber
                        
            ResultStr = "fall time = " & CStr(Falltime)
            PinName = "P53"
            Call TheExec.Datalog.WriteComment(" ")
            Call TheExec.Datalog.WriteParametricResult(SiteNum, TestNum, TestFlag, _
                ParaFlag, PinName, ChanNum, LowLimit, measVal, HighLimit, MeasUnits, _
                ForceVal, ForceUnits, 0)
        End If
        Next SiteNum
End With

Call TheExec.Datalog.WriteComment(" ")
Call TheExec.Datalog.WriteComment("End fall time interpose function")
Call TheExec.Datalog.WriteComment("================================ ")
Call TheExec.Datalog.WriteComment(" ")

        
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


Public Function ChangeVOH10Pct(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim site As Variant
    
    For Each site In TheExec.Sites.Active
        TheHdw.Digital.Pins("P50").Levels.Value(chVoh) = 0.4
        TheHdw.Digital.Pins("P50").Levels.Value(chVt) = -0.1
    Next site
    
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function

Public Function ChangeVOH90Pct(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim site As Variant
    
    For Each site In TheExec.Sites.Active
        TheHdw.Digital.Pins("P50").Levels.Value(chVoh) = 3.74
    Next site
      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function



Public Function ChangeVOL10Pct(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim site As Variant
    
    For Each site In TheExec.Sites.Active
        TheHdw.Digital.Pins("P53").Levels.Value(chVol) = 0.265
    Next site
    
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function

Public Function ChangeVOL90Pct(argc As Long, argv() As String) As Long

    On Error GoTo errHandler

    Dim site As Variant
    
    For Each site In TheExec.Sites.Active
        TheHdw.Digital.Pins("P53").Levels.Value(chVol) = 3.47
        TheHdw.Digital.Pins("P53").Levels.Value(chVt) = 4.5
    Next site
      
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function

