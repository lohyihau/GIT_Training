Attribute VB_Name = "VBT_Continuity"
Option Explicit

 
Public Function Continuity_vbt(digital_pins As PinList, power_pin As PinList, _
                            power_pin_voltage As Double, _
                            power_pin_current As Double, _
                            power_pin_current_range As Double, _
                            PPMU_current_value As Double, _
                            Optional Tnames_ As String = "Continuity_VBT") As Long
On Error GoTo errHandler
'''' Dimension object as PinListData to contain PPMU measured results
     Dim PPMUMeasure As New PinListData

'''' Offline simulation variables
     Dim site As Variant
     Dim PinNameArray() As String
     Dim NumPins As Long
     
'''' Define Spike check pinlist
'    Dim Spikecheckresult As New PinListData
'    thehdw.DCVI.SpikeCheck(power_pin).Level.Min = -0.2
'    thehdw.DCVI.SpikeCheck(power_pin).Level.Max = 6
'    thehdw.DCVI.SpikeCheck(power_pin).Enable = True
    
''''Disconnect All_Dig Pin Electronics from pins in order to connect PPMU's''''
    TheHdw.Digital.Pins(digital_pins).Disconnect
    
'''' Setup VCC to 0V
    With TheHdw.DCVS.Pins(power_pin)
        .Gate = False
        .Disconnect tlDCVSConnectDefault
        .Mode = tlDCVSModeVoltage
        .Voltage.Output = tlDCVSVoltageMain
        .Voltage.Value = power_pin_voltage
        .CurrentLimit.Sink.FoldLimit.Level = power_pin_current
        .CurrentLimit.Source.FoldLimit.Level = power_pin_current
        .CurrentRange.Value = power_pin_current_range
        .Connect tlDCVSConnectDefault
        .Gate = True
    End With
    
    TheHdw.Wait 0.001

''''Program All_Dig PPMU Pins to force CurrentValue. Connect the PPMU's and Gate on'''''
    With TheHdw.PPMU.Pins(digital_pins)
        .ForceI PPMU_current_value, 0.0002
        .Connect
        .Gate = tlOn
    End With

'''Make Measurements on PPMU pins and store in pinlistdata''''
    PPMUMeasure = TheHdw.PPMU.Pins(digital_pins).Read(tlPPMUReadMeasurements)

'''Store spike data
'    Spikecheckresult = thehdw.DCVI.SpikeCheck(power_pin).Read

''''Setup OFFLINE Simulation  ''''''''''''''''''''''''''''''''''''''''''''''''''''''
    If TheExec.TesterMode = testModeOffline Then
        TheExec.DataManager.DecomposePinList digital_pins, PinNameArray, NumPins
        For NumPins = 0 To NumPins - 1
            For Each site In TheExec.Sites
                PPMUMeasure.Pins(NumPins).Value(site) = -0.5 - (Rnd() / 23)
            Next site
        Next NumPins
    End If

    'Disconnect PPMU from digital channels
    With TheHdw.PPMU.Pins(digital_pins)
        .ForceI 0, 0.0002
        .Gate = tlOff
        .Disconnect
    End With

    
'''''''''DATALOG RESULTS''''''''''''''''''''''''''''
    TheExec.Flow.TestLimit resultVal:=PPMUMeasure, unit:=unitVolt, _
                            ForceVal:=PPMU_current_value, _
                            forceunit:=unitAmp, _
                            ForceResults:=tlForceFlow
''    TheExec.Flow.TestLimit resultVal:=Spikecheckresult
    Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function


Public Function OpenShort_VBT(PatternFile As Pattern, InitHiZPins As PinList)

    On Error GoTo errHandler

'  Apply HSD levels, Init States, Float Pins  and PowerSupply pin values
'  Connect all pins,load levels,load timings,no hot-switching
    TheHdw.Digital.ApplyLevelsTiming True, True, True, tlUnpowered, , , InitHiZPins.Value

'  Test pattern ti245_func. Set pass fail flag as Always report to datalog
'  and set it to not stop on first failure
    TheHdw.Patterns(PatternFile).test pfAlways, 0
        
Exit Function
errHandler:
    If AbortTest Then Exit Function Else Resume Next
End Function

