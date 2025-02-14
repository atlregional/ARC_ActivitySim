

;------------------------------------------------------
;  FILES AND PARAMETERS SECTION
;------------------------------------------------------
;{title,note,12,"Check Transit Routes"}
;{keys,note,"Model Keys"}
;{network,Filename,"Highway Network",x,"arc_2015.gdb\arc15hwy","GDB Network (*.*)|*.*"}
;{troutes1,Filename,"Premium Transit Routes",x,"arc_2015.gdb\PremiumTrn15","PT Lines (*.lin)|*.lin"}
;{troutes2,Filename,"Non-Premium Transit Routes",x,"ARC_2015.gdb\NonPremiumTrn15","PT Lines (*.lin)|*.lin"}
;{totzones,editbox,"Total Zones (w/Externals)",N,"6031"}

; write gdb network to binary network file
RUN PGM=NETWORK
  NETI="{network}"
	NETO="input.net"
ENDRUN

RUN PGM=PUBLIC TRANSPORT
  NETI="input.net"
  LINEI[1]="{troutes1}"  
  LINEI[2]="{troutes2}"  

FACTORI[1]=..\PARAMETERS\TRANSIT_WALK.FAC
SYSTEMI=..\PARAMETERS\TRANSIT_SYSTEM.DAT
FAREI=..\PARAMETERS\TRANSIT_FARES.FAR
;AM PEAK - USE PERIOD 2
PARAMETERS HDWAYPERIOD=2,
 TRANTIME[1]=LI.DISTANCE,
 TRANTIME[2]=LI.DISTANCE,
 TRANTIME[3]=LI.DISTANCE,
 TRANTIME[4]=LI.DISTANCE,
 TRANTIME[5]=LI.DISTANCE,
 TRANTIME[14]=LI.DISTANCE,
 TRANTIME[15]=LI.DISTANCE,
 TRANTIME[16]=LI.DISTANCE,
 TRANTIME[17]=LI.DISTANCE,
 TRANTIME[18]=LI.DISTANCE,
 TRANTIME[24]=LI.DISTANCE,
 TRANTIME[25]=LI.DISTANCE,
 TRANTIME[26]=LI.DISTANCE,
 TRANTIME[27]=LI.DISTANCE,
 TRANTIME[28]=LI.DISTANCE,
 TRANTIME[34]=LI.DISTANCE,
 TRANTIME[35]=LI.DISTANCE,
 TRANTIME[36]=LI.DISTANCE,
 TRANTIME[37]=LI.DISTANCE,
 TRANTIME[38]=LI.DISTANCE,
 TRANTIME[44]=LI.DISTANCE,
 TRANTIME[45]=LI.DISTANCE,
 TRANTIME[46]=LI.DISTANCE,
 TRANTIME[47]=LI.DISTANCE,
 TRANTIME[48]=LI.DISTANCE,
 TRANTIME[54]=LI.DISTANCE,
 TRANTIME[55]=LI.DISTANCE,
 TRANTIME[56]=LI.DISTANCE,
 TRANTIME[57]=LI.DISTANCE,
 TRANTIME[58]=LI.DISTANCE,
 TRANTIME[59]=LI.DISTANCE,
 TRANTIME[64]=LI.DISTANCE,
 TRANTIME[65]=LI.DISTANCE,
 TRANTIME[66]=LI.DISTANCE,
 TRANTIME[67]=LI.DISTANCE,
 TRANTIME[68]=LI.DISTANCE,
 TRANTIME[74]=LI.DISTANCE,
 TRANTIME[75]=LI.DISTANCE,
 TRANTIME[76]=LI.DISTANCE,
 TRANTIME[77]=LI.DISTANCE,
 TRANTIME[78]=LI.DISTANCE,
 TRANTIME[100]=LI.DISTANCE,
 USERCLASSES=1

PHASE=NODEREAD
 MAXNODE=MAX(1,NI.N)
ENDPHASE

; BUILD TRANSIT SUPPORT LINKS ===========================
PHASE=DATAPREP

  NUMZONES1={totzones}+1

  GENERATE, ; TRANSFER LINKS (between stops - not explicitly coded in network)
   NTLEGMODE=5,
   COST=LI.DISTANCE,
   MAXCOST=999*0.1,  
   FROMNODE=NUMZONES1-MAXNODE,TONODE=NUMZONES1-MAXNODE

  GENERATE, ; WALK TO/FROM TRANSIT
   NTLEGMODE=1,
   COST=LI.DISTANCE,
   
   MAXCOST=999*1,MAXNTLEGS=999*99,ONEWAY=F,DIRECTION=3,EXCLUDELINK=(LI.FACTYPE=1-9,99)   ;restricted access & fixed transit guideway links

ENDPHASE
;TRANSIT SKIMS
PHASE=SKIMIJ
 MW[11]=FAREA(0,ALLMODES)                                                                               ;FARE
ENDPHASE
ENDRUN
