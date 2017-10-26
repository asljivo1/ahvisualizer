../analyzebatch.pl \
../coapsims/ \
config=NRawSta,DataMode,TrafficInterval,PayloadSize,BeaconInterval,Name,PropagationLossExponent,PropagationLossReferenceLoss,APAlwaysSchedulesForNextSlot,MinRTO,SimulationTime,TrafficType,TrafficIntervalDeviation,TCPSegmentSize,TCPInitialSlowStartThreshold,TCPInitialCwnd,MaxTimeOfPacketsInQueue,IPCameraMotionPercentage,IPCameraMotionDuration,IPCameraDataRate,NSta,CoolDownPeriod,FirmwareSize,FirmwareBlockSize,FirmwareCorruptionProbability,FirmwareNewUpdateProbability,SensorMeasurementSize,NGroup,SlotFormat,NRawSlotCount,NRawSlotDuration,NRawSlotNum,ContentionPerRAWSlot,ContentionPerRAWSlotOnlyInFirstGroup,numOfRpsElements \
stats=edcaqueuelength,totalnumberofdrops,numberofmactxmissedack,numberoftransmissions,NumberOfDroppedPackets,AveragePacketSentReceiveTime,DropTCPTxBufferExceeded,totaldozetime,jitter,reliability,interPacketDelayAtServer,interPacketDelayAtClient,interPacketDelayDeviationPercentageAtServer,interPacketDelayDeviationPercentageAtClient \
$@