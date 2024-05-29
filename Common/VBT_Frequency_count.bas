Attribute VB_Name = "VBT_Frequency_count"
Option Explicit
Public Function MeasureFrequency(PatName As Pattern, _
                                 PinToMeasure As PinList, _
                                 TimeInterval As Double, _
                                 LowLimit As Double, _
                                 HighLimit As Double, _
                                 EvntSrc As FreqCtrEventSrcSel, _
                                 EvntSlope As FreqCtrEventSlopeSel) As Long

    Dim site As Variant
    Dim ReadFreqCnt As New PinListData
    Dim MeasFreq As New PinListData

    On Error GoTo errHandler

    ' Load level and timing.
    TheHdw.Digital.ApplyLevelsTiming True, True, True, tlPowered

    ' Clear and reset the frequency counter.
    Call TheHdw.Digital.Pins(PinToMeasure).FreqCtr.Clear

    ' Set up the frequency counter based on passed-in parameter values.
    With TheHdw.Digital.Pins(PinToMeasure).FreqCtr
        .EventSource = EvntSrc   ' VOH or VOL
        .EventSlope = EvntSlope  ' Positive or Negative
        .Enable = IntervalEnable
        .Interval = TimeInterval ' Period Counter Interval in seconds
    End With

    ' Print results to datalog.
    Call TheExec.Datalog.WriteComment(" ")
    Call TheExec.Datalog.WriteComment("===================")
    Call TheExec.Datalog.WriteComment("Running Frequency counter test..")
    Call TheExec.Datalog.WriteComment("Time interval = " & TimeInterval * 1000 & " ms")
    Call TheExec.Datalog.WriteComment(" ")

    ' Load and start pattern.
    TheHdw.Patterns(PatName).Load
    TheHdw.Patterns(PatName).Start

    ' Start the frequency counter and read measurements for all sites.
    TheHdw.Digital.Pins(PinToMeasure).FreqCtr.Start
    ReadFreqCnt = TheHdw.Digital.Pins(PinToMeasure).FreqCtr.Read

    ' Read back the time interval from HW to account for resolution rounding error.
    TimeInterval = TheHdw.Digital.Pins(PinToMeasure).FreqCtr.Interval

    ' Divide count by time interval to calculate frequency.
    MeasFreq = ReadFreqCnt.Math.Divide(TimeInterval)

    ' Halt the pattern.
    TheHdw.Digital.Patgen.Halt

    ' Apply test limits. Typical frequency is 2.5MHz. Set high & low limits accordingly.
    Call TheExec.Flow.TestLimit(resultVal:=MeasFreq, lowval:=LowLimit, _
                             hival:=HighLimit, ScaleType:=scaleKilo, unit:=unitHz)

    Call TheExec.Datalog.WriteComment(" ")

    ' Loop through sites and print results to datalog.
    For Each site In TheExec.Sites
        Call TheExec.Datalog.WriteComment("Number of pulses = " & ReadFreqCnt)
        Call TheExec.Datalog.WriteComment("Frequency of pin " & PinToMeasure & _
                                          " Site:" & site & " is = " & (MeasFreq / 1000) & " KHz")
    Next site

    Call TheExec.Datalog.WriteComment(" ")

    Exit Function

errHandler:
    TheExec.AddOutput "Error in the Frequency Counter Test"
End Function



