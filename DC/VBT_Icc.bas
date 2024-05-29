Attribute VB_Name = "VBT_Icc"
Option Explicit

Public Function icc_static_vbt(power_pin As PinList, Vcc_Value As Double, _
                            meter_current_range As Double, Init_HiPins As PinList, _
                            Optional Tnames_ As String = "Icc_static") As Long
    
    Dim site As Variant
    Dim IccMeasure As New PinListData
      
    ' Power down Vcc before start of the IDD Static Test.
    'With TheHdw.DCVS.Pins(power_pin)
    '    .Gate = False
    '    .Disconnect tlDCVSConnectDefault
    '    .Mode = tlDCVSModeVoltage
    '    .Voltage.Output = tlDCVSVoltageMain
    '    .Voltage.Value = 0
    '    '.CurrentLimit.Sink.FoldLimit.Level = power_pin_current
    '    '.CurrentLimit.Source.FoldLimit.Level = power_pin_current
    '    '.CurrentRange.Value = power_pin_current_range
    '    .Connect tlDCVSConnectDefault
    '    .Gate = True
    'End With

    'TheHdw.Digital.Pins("All_Pins").Disconnect
    
''''Wait 100ms'''
    'TheHdw.Wait 0.1
      
''''Apply HSD levels, Init States, and PowerSupply pin values''''
''''Connect all pins, load levels, do not load timing (not needed), do not hot-switch'''
''''Setup initial state of pins as hi, low, and hi-z''''
    TheHdw.Digital.ApplyLevelsTiming True, True, False, tlPowered, Init_HiPins.Value

    TheHdw.Digital.Pins("All_Pins").Disconnect

''''''Setup VCC pin to measure Current at 200mA range''''
    With TheHdw.DCVS.Pins(power_pin)
        .Meter.Mode = tlDCVSMeterCurrent
    End With

''''Wait 10ms'''
    TheHdw.Wait 0.01

''''Strobe the meter on the VCC pin and store it in an pinlistdata variable defined'''
    IccMeasure = TheHdw.DCVS.Pins(power_pin).Meter.Read(tlStrobe)
    
''''Setup OFFLINE sim by stuffing the pinlistdata variable with simulation data''''
    If TheExec.TesterMode = testModeOffline Then
    For Each site In TheExec.Sites.Existing
        IccMeasure.Pins(0).Value(site) = 0.028 + Rnd / 99
    Next site
    End If
    
''''Datalog Results''''
    TheExec.Flow.TestLimit resultVal:=IccMeasure, unit:=unitAmp, Tname:="Icc_Static_VBT", _
                                    PinName:=power_pin, ForceVal:=Vcc_Value, _
                                    forceunit:=unitVolt, ForceResults:=tlForceFlow
    
End Function


Public Function Icc_dynamic_vbt(PatternFile As Pattern, power_pin As PinList, Vcc_Value As Double, _
                            power_pin_current As Double, meter_current_range As Double, Init_HiPins As PinList, _
                            Optional Tnames_ As String = "Icc_Icc_dynamic") As Long
    On Error GoTo errHandler

     
    Dim site As Variant
    Dim IccMeasure As New PinListData

'''''Apply HSD levels, Init States, and PowerSupply pin values''''
'''''Connect all pins,load levels and timing,do not hot-switch'''
    TheHdw.Digital.ApplyLevelsTiming True, True, True, tlPowered, Init_HiPins.Value

'''''''''Setup VCC pin to measure Current at 200mA range'''''
    With TheHdw.DCVS.Pins(power_pin)
        .Gate = False
        .Disconnect tlDCVSConnectDefault
        .Mode = tlDCVSModeVoltage
        .Voltage.Output = tlDCVSVoltageMain
        .Voltage.Value = Vcc_Value
        '.CurrentLimit.Sink.FoldLimit.Level = power_pin_current
        '.CurrentLimit.Source.FoldLimit.Level = power_pin_current
        .CurrentRange.Value = meter_current_range
        .Meter.Mode = tlDCVSMeterCurrent
        .Connect tlDCVSConnectDefault
        .Gate = True
    End With

    TheHdw.Patterns(PatternFile).Load

    TheHdw.Patterns(PatternFile).Start ("")

'''Wait 10ms'''
    TheHdw.Wait 0.01

'''Strobe the meter on the VCC pin and store it in an pinlistdata variable defined''''
    IccMeasure = TheHdw.DCVS.Pins(power_pin).Meter.Read(tlStrobe)
    Dim status As Boolean
    '''Wait for the meter to finish taking the measurement ''''
    
    'Do While status = "1"
    '    status = TheHdw.DCVI.Pins(power_pin).Capture.IsCaptureDone
    'Loop

    TheHdw.Digital.Patgen.Continue None, cpuA

    TheHdw.Digital.Patgen.HaltWait

''''Setup OFFLINE Simulation by stuffing the pinlistdata variable with simulation data'''''''
    If TheExec.TesterMode = testModeOffline Then
        For Each site In TheExec.Sites
            IccMeasure.Pins(0).Value(site) = 0.028 + Rnd / 99
        Next site
    End If

    'With TheHdw.DCVI.Pins(power_pin)
    '    .Voltage = 0
    '    .Gate = False
    '    .Disconnect tlDCVIConnectDefault
    'End With

''''''''''DATALOG RESULTS''''''''''''''''''''''''''''''''''
    TheExec.Flow.TestLimit resultVal:=IccMeasure, unit:=unitAmp, Tname:="Icc_Dynamic_VBT", _
                                    PinName:=power_pin, ForceVal:=Vcc_Value, _
                                    forceunit:=unitVolt, ForceResults:=tlForceFlow
    
Exit Function
errHandler:
     If AbortTest Then Exit Function Else Resume Next
End Function




