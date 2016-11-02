Imports CSFacturaElectronica
Imports CSLog

Module Module1

  Private m_fe As cFacturaElectronica

  Sub Main()

    cLog.addListener(New cLogMessage)

    m_fe = New cFacturaElectronica

    m_fe.initProcess()

    Do

    Loop

  End Sub

End Module
