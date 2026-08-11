        TITLE   ### APPLE PANIC ###
;               -------------------
PROT    EQU     2
DISK    EQU     1
TAPE    EQU     0
TYPE    EQU     DISK
;
        COND    0!(TYPE=TAPE)!(TYPE=DISK)
        ORG     3C00H+44
        DEFB    191
        DEFM    ' APPLE PANIC     **'
        ORG     3C40H+44
        DEFB    191
        DEFM    ' TRS-80 - MOD I/III'
        ORG     3C80H+44
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        DEFW    8383H
        ENDC
        COND    TYPE=PROT
        ORG     4800H
        ENDC
        COND    TYPE=TAPE
        ORG     4300H
        ENDC
        COND    TYPE=DISK
        INCLUDE SYSMACRO
        ORG     8000H
        ENDC
        INCLUDE PANIC1
        INCLUDE INIT
NPHASE  LD      A,(DCPH1)
        OR      A
        JR      NZ,NPH00
        LD      A,(NBRE)
        OR      A
        RET     NZ
        LD      A,(BASE)
        OR      A
        JR      Z,NPH01
        CALL    BONUS0
        CALL    CMUR
        CALL    SONH3
NPH01   LD      A,8
        LD      (WPHA),A
        LD      A,(PLAY)
        CP      1
        JR      NZ,NPH0
        LD      HL,PHASE1
        JR      NPH1
NPH0    LD      HL,PHASE2
NPH1    LD      A,(BASE)
        OR      A
        JR      Z,NPH2
        LD      A,(HL)
        CP      7
        JR      Z,NPH2
        INC     (HL)
NPH2    LD      A,(HL)
        DEC     A
        SLA     A
        LD      E,A
        LD      D,0
        LD      HL,TPHASE
        ADD     HL,DE
        LD      A,(HL)
        INC     HL
        LD      (DCPH2),A
        LD      A,(HL)
        LD      (DCPH1),A
        CALL    CBASE
        RET
NPH00   LD      A,(WPHA)
        OR      A
        JR      Z,NPH02
        DEC     A
        LD      (WPHA),A
        RET
NPH02   LD      A,8
        LD      (WPHA),A
        LD      IX,TALIEN
        LD      C,2
        LD      A,(DCPH2)
        OR      A
        JR      NZ,NPH
        DEC     C
NPH     LD      A,C
        LD      (GENRE),A
NPH3    RANDOM  0,9
        LD      (X),A
        RANDOM  0,3
        LD      (Y),A
        OR      A
        JR      Z,NPH4
        CALL    CASE
        LD      DE,-10
        ADD     HL,DE
        BIT     3,(HL)
        JR      NZ,NPH3
NPH4    LD      A,(IX)
        OR      A
        JR      Z,NPH5
        LD      A,(X)
        CP      (IX+5)
        JR      NZ,NPH6
        LD      A,(Y)
        CP      (IX+6)
        JR      Z,NPH02
NPH6    LD      DE,8
        ADD     IX,DE
        JR      NPH4
NPH5    LD      A,(GENRE)
        LD      (IX),A
        RANDOM  0,1
        SLA     A
        ADD     A,1
        LD      (IX+4),A
        LD      (IX+7),0
        LD      A,(X)
        LD      (IX+5),A
        LD      A,(Y)
        LD      (IX+6),A
        LD      (IX+1),4
        LD      A,(Y)
        LD      B,A
        LD      DE,192
        CALL    MUL16
        LD      A,(X)
        LD      B,A
        SLA     A
        ADD     A,B
        SLA     A
        LD      E,A
        LD      D,0
        ADD     HL,DE
        LD      DE,SCR+64+3
        ADD     HL,DE
        LD      (IX+2),L
        LD      (IX+3),H
        CALL    SONYL
        LD      HL,NBRE
        INC     (HL)
        LD      A,(DCPH2)
        OR      A
        JR      Z,NPH7
        DEC     A
        LD      (DCPH2),A
        RET
NPH7    LD      A,(DCPH1)
        DEC     A
        LD      (DCPH1),A
        OR      A
        RET     NZ
        CALL    BONUS1
        LD      A,1
        LD      (BASE),A
        RET
GENRE   DEFB    0
SONYL   LD      C,50
NYL0    LD      A,1
        OUT     (255),A
        LD      B,50
        DJNZ    $
        XOR     A
        OUT     (255),A
        LD      B,50
        DJNZ    $
        DEC     C
        JR      NZ,NYL0
        RET
SONH3   LD      BC,4000H
        CALL    PAUSE
        JP      MUSIC0
BONUS0  LD      A,1
        LD      (MOVIN),A
        CALL    SCOR12
        LD      BC,4
        ADD     HL,BC
        LD      DE,BONUS+4
BUN0    LD      A,(DE)
        SUB     '0'
        ADD     A,(HL)
        ADD     A,B
        CP      '9'+1
        JR      C,BUN3
        LD      B,1
        SUB     10
BUN1    CP      '9'+1
        JR      C,BUN2
        SUB     10
        INC     B
        JR      BUN1
BUN2    LD      (HL),A
        DEC     C
        DEC     HL
        DEC     DE
        JP      P,BUN0
        LD      HL,BONUS
        LD      DE,BONUS+1
        LD      BC,5
        LD      (HL),'0'
        LDIR
        RET
BUN3    LD      B,0
        JR      BUN2
BONUS1  XOR     A
        LD      (MOVIN),A
        LD      A,(PLAY)
        CP      1
        JR      NZ,BON0
        LD      HL,PHASE1
        JR      BON1
BON0    LD      HL,PHASE2
BON1    LD      A,(HL)
        DEC     A
        LD      B,A
        SLA     A
        ADD     A,B
        SLA     A
        LD      E,A
        LD      D,0
        LD      HL,TTBON
        ADD     HL,DE
        LD      DE,BONUS
        LD      BC,6
        LDIR
        RET
TTBON   DEFM    '003000'
        DEFM    '004000'
        DEFM    '005000'
        DEFM    '007000'
        DEFM    '009000'
        DEFM    '011000'
        DEFM    '012000'
MBONUS  LD      A,(MOVIN)
        OR      A
        RET     NZ
MBO0    LD      A,0
        INC     A
        AND     7
        LD      (MBO0+1),A
        RET     NZ
        LD      HL,BONUS
        LD      BC,4
        ADD     HL,BC
MBO1    LD      A,(HL)
        DEC     A
        CP      '0'-1
        JR      NZ,MBO4
        ADD     A,10
        LD      (HL),A
        DEC     C
        DEC     HL
        JP      P,MBO1
        LD      HL,BONUS
        LD      DE,BONUS+1
        LD      BC,5
        LD      (HL),'0'
        LDIR
        LD      A,2
        LD      (BASE),A
        LD      A,(PLAY)
        CP      1
        LD      A,0
        JR      NZ,MBO2
        LD      (SHP1),A
        RET
MBO2    LD      (SHP2),A
        RET
MBO4    LD      (HL),A
        RET
        COND    TYPE=TAPE
TRCLN   LD      A,(BASE)
        CP      1
        RET     NZ
        LD      H,40H
        LD      L,0E1H
        INC     H
        INC     L
        LD      A,(HL)
        DEC     A
        CP      79H
        JR      NZ,CLEAN
        INC     HL
        LD      A,(HL)
        DEC     A
        CP      7FH
        JR      NZ,CLEAN
        INC     HL
        LD      A,(HL)
        DEC     A
        CP      42H
        RET     Z
CLEAN   LD      HL,8000H
        LD      DE,4000H
        LD      BC,8000H
        LDIR
        RET
        ENDC
        COND    TYPE=PROT
TRCLN   LD      A,(BASE)
        CP      1
        RET     NZ
        LD      H,44H
        LD      L,10H
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        EX      DE,HL
        XOR     A
        LD      (HL),A
        CP      (HL)
        JP      Z,CLEANP
        DEC     HL
        LD      (HL),A
        CP      (HL)
        JP      NZ,CLEANP
        LD      A,(9000H)
        CP      0CDH
        JP      NZ,CLEANP
        RET
        ENDC
DALIEN  LD      IX,TALIEN
        LD      B,8
DAL0    PUSH    BC
        LD      A,(IX)
        LD      B,A
        AND     0FCH
        JR      NZ,DAL1
        LD      A,B
        AND     3
        JR      Z,DAL1
        DEC     A
        SLA     A
        SLA     A
        LD      E,A
        LD      D,0
        LD      A,(IX+4)
        CP      2
        JR      NC,DAL5
        INC     DE
        INC     DE
DAL5    LD      HL,TADD
        ADD     HL,DE
        EX      DE,HL
        LD      C,(IX+1)
        LD      B,0
        LD      HL,TCAL
        ADD     HL,BC
        LD      L,(HL)
        LD      H,0
        LD      A,(DE)
        LD      C,A
        INC     DE
        LD      A,(DE)
        LD      B,A
        ADD     HL,BC
        EX      DE,HL
        LD      L,(IX+2)
        LD      H,(IX+3)
        LD      B,3
DAL2    LD      C,4
DAL3    LD      A,(DE)
        OR      (HL)
        LD      (HL),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,DAL3
        DJNZ    DAL4
        JR      DAL1
DAL4    PUSH    DE
        LD      DE,60
        ADD     HL,DE
        POP     DE
        JR      DAL2
DAL1    LD      DE,8
        ADD     IX,DE
        POP     BC
        DJNZ    DAL0
        RET
ALTA    DEFB    0
MALIEN  LD      A,(ALTA)
        INC     A
        AND     7
        LD      (ALTA),A
        LD      IX,TALIEN
        LD      B,8
MAL0    PUSH    BC
        LD      A,(IX)
        OR      A
        JP      Z,MAL1
        AND     0FCH
        JP      NZ,MAL2
        LD      A,(MOVIN)
        OR      A
        JP      NZ,MAL1
        LD      A,(IX+7)
        OR      A
        JP      Z,MAL3
MAL4    LD      A,(IX+4)
        OR      A
        JR      Z,MALU
        DEC     A
        JR      Z,MALR
        DEC     A
        JR      Z,MALD
        JR      MALL
MALU    LD      A,(ALTA)
        AND     1
        JR      Z,MAL1
MALU1   DEC     (IX+7)
        LD      A,(IX+7)
        CP      256-9
        JR      NZ,MALU0
        LD      (IX+7),0
        DEC     (IX+6)
MALU0   LD      DE,0FFH
        JR      MOVER
MALR    INC     (IX+7)
        LD      A,(IX+7)
        CP      12
        JR      NZ,MALR0
        LD      (IX+7),0
        INC     (IX+5)
MALR0   LD      DE,100H
        JR      MOVER
MALD    LD      A,(ALTA)
        AND     1
        JR      Z,MAL1
MALD1   INC     (IX+7)
        LD      A,(IX+7)
        CP      9
        JR      NZ,MALD0
        LD      (IX+7),0
        INC     (IX+6)
MALD0   LD      DE,1
        JR      MOVER
MALL    DEC     (IX+7)
        LD      A,(IX+7)
        CP      256-12
        JR      NZ,MALL0
        LD      (IX+7),0
        DEC     (IX+5)
MALL0   LD      DE,0FF00H
MOVER   LD      B,(IX+1)
        LD      L,(IX+2)
        LD      H,(IX+3)
        CALL    MOVE
        LD      (IX+3),H
        LD      (IX+2),L
        LD      (IX+1),B
MAL1    LD      DE,8
        ADD     IX,DE
        POP     BC
        DEC     B
        JP      NZ,MAL0
        RET
MAL3    LD      A,(IX+5)
        LD      (X),A
        LD      A,(IX+6)
        LD      (Y),A
        CALL    CASE
        LD      A,(HL)
        AND     7
        JR      Z,MAL3S
        LD      IY,TALIEN
        LD      B,8
MALS0   LD      A,(IY)
        AND     0FCH
        JR      Z,MALS1
        BIT     2,A
        JR      NZ,MALS1
        LD      A,(IY+5)
        CP      (IX+5)
        JR      NZ,MALS1
        LD      A,(IY+6)
        CP      (IX+6)
        JR      Z,MAL3S
MALS1   LD      DE,8
        ADD     IY,DE
        DJNZ    MALS0
        LD      A,(HL)
        AND     7
        CP      4
        JR      NZ,MALS10
        LD      A,(IX)
        AND     3
        ADD     A,0F8H
        LD      (IX),A
        LD      (IX+7),4
        LD      (IX+4),2
        LD      DE,4
        JP      MOVER
MALS10  LD      A,(IX)
        AND     3
        ADD     A,10H
        LD      (IX),A
        LD      (IX+7),1
        LD      (IX+4),2
        LD      DE,1
        JP      MOVER
MAL3S   LD      A,(IX+5)
        OR      A
        JR      Z,MAL9
        CP      9
        JR      Z,MAL9
        LD      A,(IX+5)
        LD      (X),A
        LD      A,(IX+6)
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        JR      NZ,MAL9
        LD      A,(Y)
        OR      A
        JP      Z,MAL4
        DEC     A
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        JP      Z,MAL4
MAL9    RANDOM  0,1
        OR      A
        LD      A,3CH
        JR      Z,MAL5
        INC     A
MAL5    LD      (MAL6),A
        RANDOM  0,3
MAL7    PUSH    AF
        OR      A
        JR      Z,MLAU
        DEC     A
        JR      Z,MLAR
        DEC     A
        JR      Z,MLAD
        JR      MLAL
MLAU    LD      A,(IX+6)
        OR      A
        JR      Z,MAL8
        DEC     A
        LD      (Y),A
        LD      A,(IX+5)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,MAL8
        POP     AF
        LD      (IX+4),A
        JP      MALU
MLAR    LD      A,(IX+5)
        CP      9
        JR      Z,MAL8
        POP     AF
        LD      (IX+4),A
        JP      MALR
MLAD    LD      A,(IX+6)
        CP      4
        JR      Z,MAL8
        LD      (Y),A
        LD      A,(IX+5)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,MAL8
        POP     AF
        LD      (IX+4),A
        JP      MALD
MLAL    LD      A,(IX+5)
        OR      A
        JR      Z,MAL8
        POP     AF
        LD      (IX+4),A
        JP      MALL
MAL8    POP     AF
MAL6    INC     A
        AND     3
        JR      MAL7
MAL2    LD      A,(IX)
        BIT     2,A
        JR      NZ,MAL2S
        LD      A,(ALTA)
        AND     1
        JP      NZ,MAL1
        LD      A,(MOVIN)
        OR      A
        JP      NZ,MAL1
        LD      A,(ALTA)
        OR      A
        JP      NZ,MAL1
        LD      A,(IX)
        SUB     8
        LD      (IX),A
        SRL     A
        SRL     A
        SRL     A
        CP      5
        JP      NC,MAL1
        OR      A
        JR      Z,MALS2
        LD      (IX+4),0
        JP      MALU1
MALS2   LD      A,(IX+5)
        LD      (X),A
        LD      A,(IX+6)
        LD      (Y),A
        CALL    CASE
        LD      (HL),0
        RANDOM  0,1
        SLA     A
        ADD     A,1
        LD      (IX+4),A
        JP      MAL1
MAL2S   LD      A,(IX+7)
        OR      A
        JP      NZ,MALD1
        LD      A,(IX+5)
        LD      (X),A
        LD      A,(IX+6)
        LD      (Y),A
        CALL    CASE
        LD      A,(HL)
        AND     7
        CP      4
        JR      NZ,MALS3
        LD      IY,TALIEN
        LD      B,8
MALS4   LD      A,(IY)
        AND     0FCH
        JR      Z,MALS5
        BIT     2,A
        JR      NZ,MALS5
        LD      A,(IY+5)
        CP      (IX+5)
        JR      NZ,MALS5
        LD      A,(IY+6)
        CP      (IX+6)
        JR      NZ,MALS5
        LD      B,0CH
        LD      A,(IY+7)
        OR      A
        JR      NZ,CRK
        LD      B,4
CRK     LD      A,(IY)
        AND     3
        OR      B
        LD      (IY),A
        LD      (IY+4),2
        LD      HL,MOVIN
        INC     (HL)
        JP      MAL1
MALS5   LD      DE,8
        ADD     IY,DE
        DJNZ    MALS4
        LD      A,(IX)
        ADD     A,8
        LD      (IX),A
        JP      MALD1
MALS3   LD      A,(IX)
        SRL     A
        SRL     A
        SRL     A
        LD      B,A
        PUSH    BC
        LD      A,(IX+5)
        LD      (X),A
        LD      A,(IX+6)
        LD      (Y),A
        CALL    CASE
        POP     BC
MALS7   PUSH    BC
        LD      DE,-10
        ADD     HL,DE
        LD      (HL),0
        PUSH    HL
        CALL    ADDPO
        POP     HL
        POP     BC
        DJNZ    MALS7
        LD      A,(IX)
        AND     3
        LD      B,A
        LD      A,(IX)
        SRL     A
        SRL     A
        SRL     A
        CP      B
        JR      NC,MALS9
        LD      (IX),B
        RANDOM  0,1
        SLA     A
        ADD     A,1
        LD      (IX+4),A
        JR      MALS8
MALS9   LD      (IX),0
        LD      HL,NBRE
        DEC     (HL)
        CALL    SONH2
MALS8   LD      HL,MOVIN
        DEC     (HL)
        JP      MAL1
SONH2   LD      L,50H
NH2     LD      A,1
        OUT     (255),A
        LD      B,L
        DJNZ    $
        XOR     A
        OUT     (255),A
        LD      B,L
        DJNZ    $
        DEC     L
        LD      A,L
        CP      20H
        JR      NZ,NH2
        RET
ADDPO   LD      D,1
        LD      BC,3
        CALL    SCOR12
        ADD     HL,BC
ADP0    LD      A,(HL)
        ADD     A,D
        CP      '9'+1
        JR      C,ADP3
        LD      D,1
        SUB     10
ADP1    CP      '9'+1
        JR      C,ADP2
        SUB     '9'+1
        INC     D
        JR      ADP1
ADP2    LD      (HL),A
        DEC     C
        DEC     HL
        JP      P,ADP0
        RET
ADP3    LD      (HL),A
        RET
CBASE   XOR     A
        LD      (BASE),A
        LD      (BADIR),A
        LD      (BADEC),A
        LD      (BADIG),A
        LD      A,4
        LD      (BAC),A
        LD      (BAY),A
        LD      A,3
        LD      (Y),A
        LD      A,4
CBA0    LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,CBA1
        LD      A,(X)
        INC     A
        JR      CBA0
CBA1    LD      A,(X)
        LD      (BAX),A
        LD      B,A
        SLA     A
        ADD     A,B
        SLA     A
        LD      E,A
        LD      D,0
        LD      HL,SCR+832+3
        ADD     HL,DE
        LD      (BAHL),HL
        RET
DBASE   LD      A,(BASE)
        CP      1
        RET     NZ
        LD      A,(BAC)
        LD      E,A
        LD      D,0
        LD      HL,TCAL
        ADD     HL,DE
        LD      L,(HL)
        LD      H,0
        LD      A,(BADIR)
        CP      3
        JR      NC,DBA0
        LD      DE,6*12
        ADD     HL,DE
DBA0    LD      DE,TBASE
        ADD     HL,DE
        EX      DE,HL
        LD      HL,(BAHL)
        LD      B,3
        EXX
        LD      E,0
        EXX
DBA1    LD      C,4
DBA2    LD      A,(DE)
        AND     (HL)
        EXX
        OR      E
        LD      E,A
        EXX
        LD      A,(DE)
        OR      (HL)
        LD      (HL),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,DBA2
        DJNZ    DBA3
        JR      DBA4
DBA3    PUSH    DE
        LD      DE,60
        ADD     HL,DE
        POP     DE
        JR      DBA1
DBA4    EXX
        LD      A,E
        AND     3FH
        RET     Z
        LD      A,2
        LD      (BASE),A
        LD      A,(PLAY)
        CP      1
        JR      NZ,DBA5
        LD      HL,SHP1
        JR      DBA6
DBA5    LD      HL,SHP2
DBA6    DEC     (HL)
        RET
MBASED  LD      A,(DEMO)
        OR      A
        RET     Z
        LD      A,(BASE)
        CP      1
        RET     NZ
        LD      A,(BADIG)
        OR      A
        RET     NZ
        LD      A,(BADEC)
        OR      A
        RET     NZ
        LD      A,(DIRD)
        OR      A
        JR      Z,DEMU
        DEC     A
        JR      Z,DEMR
        DEC     A
        JR      Z,DEMD
        JR      DEML
DEMU    LD      A,(BAY)
        OR      A
        JR      Z,TURN
        DEC     A
DEM1    LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,TURN
DEM0    LD      A,(DIRDW)
        DEC     A
        LD      (DIRDW),A
        RET     NZ
        JR      TURN
DEMR    LD      A,(BAX)
        CP      9
        JR      Z,TURN
        LD      A,(BAY)
        OR      A
        JR      Z,DEM0
        DEC     A
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      NZ,TURN
        JR      DEM0
DEMD    LD      A,(BAY)
        CP      4
        JR      Z,TURN
        JR      DEM1
DEML    LD      A,(BAX)
        OR      A
        JR      Z,TURN
        LD      A,(BAY)
        OR      A
        JR      Z,DEM0
        DEC     A
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      NZ,TURN
        JR      DEM0
TURN    RANDOM  0,6
        LD      (DIRDW),A
        RANDOM  0,1
        OR      A
        LD      A,3CH
        JR      Z,DEM2
        INC     A
DEM2    LD      (DEM3),A
        RANDOM  0,2
        AND     2
DEM4    PUSH    AF
        OR      A
        JR      Z,DENU
        DEC     A
        JR      Z,DENR
        DEC     A
        JR      Z,DEND
        JR      DENL
DENU    LD      A,(BAY)
        OR      A
        JR      Z,TURN0
        DEC     A
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,TURN0
        POP     AF
        LD      (DIRD),A
        LD      A,0FFH
        LD      (DIRDV),A
        XOR     A
        LD      (DIRDH),A
        RET
DENR    LD      A,(BAX)
        CP      9
        JR      Z,TURN0
        POP     AF
        LD      (DIRD),A
        LD      A,1
        LD      (DIRDH),A
        XOR     A
        LD      (DIRDV),A
        RET
DEND    LD      A,(BAY)
        CP      4
        JR      Z,TURN0
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,TURN0
        POP     AF
        LD      (DIRD),A
        LD      A,1
        LD      (DIRDV),A
        XOR     A
        LD      (DIRDH),A
        RET
DENL    LD      A,(BAX)
        OR      A
        JR      Z,TURN0
        POP     AF
        LD      (DIRD),A
        LD      A,0FFH
        LD      (DIRDH),A
        XOR     A
        LD      (DIRDV),A
        RET
TURN0   POP     AF
DEM3    INC     A
        AND     3
        JP      DEM4
DIRD    DEFB    0
DIRDW   DEFB    1
DIRDH   DEFB    0
DIRDV   DEFB    0
MBASE   LD      A,(BASE)
        CP      1
        RET     NZ
        LD      A,(MOVIN)
        OR      A
        RET     NZ
        LD      A,(BADIG)
        OR      A
        JP      NZ,CHUTE
        LD      A,(DEMO)
        OR      A
        JR      Z,MBAX
        LD      A,(DIRDH)
        LD      H,A
        JR      MBA1
MBAX    LD      H,0
        LD      A,(3840H)
        AND     20H
        LD      B,A
        LD      A,(3820H)
        AND     10H
        OR      B
        LD      B,A
        IN      A,(0)
        CPL
        AND     4
        OR      B
        JR      Z,MBA0
        DEC     H
MBA0    LD      A,(3840H)
        AND     40H
        LD      B,A
        LD      A,(3820H)
        AND     40H
        OR      B
        LD      B,A
        IN      A,(0)
        CPL
        AND     8
        OR      B
        JR      Z,MBA1
        INC     H
MBA1    LD      A,H
        OR      A
        JR      Z,MBAY
        JP      P,MBAR
        LD      A,(BADEC)
        OR      A
        JR      Z,MBL0
        LD      A,(BADIR)
        BIT     0,A
        JR      NZ,MBAY
MBL1    LD      A,4
        LD      (BADIR),A
        JR      MBAY
MBL0    LD      A,(BAX)
        OR      A
        JR      Z,MBAY
        JR      MBL1
MBAR    LD      A,(BADEC)
        OR      A
        JR      Z,MBR0
        LD      A,(BADIR)
        BIT     0,A
        JR      NZ,MBAY
MBR1    LD      A,2
        LD      (BADIR),A
        JR      MBAY
MBR0    LD      A,(BAX)
        CP      9
        JR      NZ,MBR1
MBAY    LD      A,(DEMO)
        OR      A
        JR      Z,MBAY0
        LD      A,(DIRDV)
        LD      H,A
        JR      MBA3
MBAY0   LD      H,0
        LD      A,(3840H)
        AND     8
        LD      B,A
        IN      A,(0)
        CPL
        AND     1
        OR      B
        JR      Z,MBA2
        DEC     H
MBA2    LD      A,(3840H)
        AND     10H
        LD      B,A
        IN      A,(0)
        CPL
        AND     2
        OR      B
        JR      Z,MBA3
        INC     H
MBA3    LD      A,H
        OR      A
        JR      Z,MVBAS
        JP      P,MBAD
        LD      A,(BADEC)
        OR      A
        JR      Z,MBU0
        LD      A,(BADIR)
        BIT     0,A
        JR      Z,MVBAS
MBU1    LD      A,1
        LD      (BADIR),A
        JR      MVBAS
MBU0    LD      A,(BAY)
        OR      A
        JR      Z,MVBAS
        LD      A,(BAX)
        LD      (X),A
        LD      A,(BAY)
        DEC     A
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        JR      Z,MVBAS
        JR      MBU1
MBAD    LD      A,(BADEC)
        OR      A
        JR      Z,MBD0
        LD      A,(BADIR)
        BIT     0,A
        JR      Z,MVBAS
MBD1    LD      A,3
        LD      (BADIR),A
        JR      MVBAS
MBD0    LD      A,(BAY)
        CP      4
        JR      Z,MVBAS
        LD      A,(BAX)
        LD      (X),A
        LD      A,(BAY)
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        JR      NZ,MBD1
MVBAS   LD      A,(BADEC)
        OR      A
        JP      Z,MOVBAS
        LD      A,(BADIR)
        OR      A
        RET     Z
        DEC     A
        JR      Z,MVU
        DEC     A
        JR      Z,MVR
        DEC     A
        JR      Z,MVD
        JR      MVL
MVU     LD      A,(ALTA)
        AND     1
        RET     Z
MVU1    LD      A,(BADEC)
        DEC     A
        LD      (BADEC),A
        CP      256-9
        JR      NZ,MVU0
        XOR     A
        LD      (BADEC),A
        LD      A,(BAY)
        DEC     A
        LD      (BAY),A
MVU0    LD      DE,0FFH
        JR      MOVBA
MVR     LD      A,(BADEC)
        INC     A
        LD      (BADEC),A
        CP      12
        JR      NZ,MVR0
        XOR     A
        LD      (BADEC),A
        LD      A,(BAX)
        INC     A
        LD      (BAX),A
MVR0    LD      DE,100H
        JR      MOVBA
MVD     LD      A,(ALTA)
        AND     1
        RET     Z
MVD1    LD      A,(BADEC)
        INC     A
        LD      (BADEC),A
        CP      9
        JR      NZ,MVD0
        XOR     A
        LD      (BADEC),A
        LD      A,(BAY)
        INC     A
        LD      (BAY),A
MVD0    LD      DE,1
        JR      MOVBA
MVL     LD      A,(BADEC)
        DEC     A
        LD      (BADEC),A
        CP      256-12
        JR      NZ,MVL0
        XOR     A
        LD      (BADEC),A
        LD      A,(BAX)
        DEC     A
        LD      (BAX),A
MVL0    LD      DE,0FF00H
MOVBA   LD      A,(BAC)
        LD      B,A
        LD      HL,(BAHL)
        CALL    MOVE
        LD      (BAHL),HL
        LD      A,B
        LD      (BAC),A
        LD      A,(BADIG)
        OR      A
        RET     NZ
        LD      (FTROU),A
        RET
MOVBAS  LD      A,(BAX)
        LD      (X),A
        LD      A,(BAY)
        LD      (Y),A
        CALL    CASE
        LD      A,(HL)
        AND     7
        CP      4
        JR      NZ,MBA4
        LD      IY,TALIEN
        LD      B,8
MBA5    LD      A,(IY)
        AND     0FCH
        JR      Z,MBA6
        BIT     2,A
        JR      NZ,MBA6
        LD      A,(BAX)
        CP      (IY+5)
        JR      NZ,MBA6
        LD      A,(BAY)
        CP      (IY+6)
        JR      Z,MBA4
MBA6    LD      DE,8
        ADD     IY,DE
        DJNZ    MBA5
        LD      A,6
        LD      (BADIG),A
        JP      MVD1
MBA4    LD      A,(BADIR)
        OR      A
        RET     Z
        DEC     A
        JR      Z,MBAEU
        DEC     A
        JR      Z,MBAER
        DEC     A
        JR      Z,MBAED
        JR      MBAEL
MBAEU   LD      A,(BAY)
        OR      A
        RET     Z
        DEC     A
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        RET     Z
        JP      MVU
MBAER   LD      A,(BAX)
        CP      9
        RET     Z
        JP      MVR
MBAED   LD      A,(BAY)
        CP      4
        RET     Z
        LD      (Y),A
        LD      A,(BAX)
        LD      (X),A
        CALL    CASE
        BIT     3,(HL)
        RET     Z
        JP      MVD
MBAEL   LD      A,(BAX)
        OR      A
        RET     Z
        JP      MVL
CHUTE   LD      A,(BADIG)
        CP      6
        RET     NZ
        LD      A,(BADEC)
        OR      A
        JP      NZ,MVD
        XOR     A
        LD      (BADIG),A
        RET
EFFBAS  LD      A,(BASE)
        CP      1
        JR      Z,EFBA4
        CP      2
        RET     NZ
EFBA4   LD      A,(BAC)
        LD      E,A
        LD      D,0
        LD      HL,TCAL
        ADD     HL,DE
        LD      A,(HL)
        EXX
        LD      E,A
        LD      D,0
        LD      HL,TEFF
        ADD     HL,DE
        EXX
        LD      L,A
        LD      H,0
        LD      A,(BADIR)
        CP      3
        JR      NC,EFBA0
        LD      DE,6*12
        ADD     HL,DE
EFBA0   LD      DE,TBASE
        ADD     HL,DE
        EX      DE,HL
        LD      HL,(BAHL)
        LD      B,3
EFBA1   LD      C,4
EFBA2   LD      A,(HL)
        EXX
        AND     (HL)
        INC     HL
        EXX
        LD      (HL),A
        LD      A,(DE)
        OR      (HL)
        LD      (HL),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,EFBA2
        DJNZ    EFBA3
        RET
EFBA3   PUSH    DE
        LD      DE,60
        ADD     HL,DE
        POP     DE
        JR      EFBA1
EFFAL   LD      IX,TALIEN
        LD      B,8
EFA0    PUSH    BC
        LD      A,(IX)
        AND     3
        JR      Z,EFA1
        DEC     A
        SLA     A
        SLA     A
        LD      E,A
        LD      D,0
        LD      A,(IX+4)
        CP      2
        JR      NC,EFA5
        INC     DE
        INC     DE
EFA5    LD      HL,TADD
        ADD     HL,DE
        EX      DE,HL
        LD      C,(IX+1)
        LD      B,0
        LD      HL,TCAL
        ADD     HL,BC
        LD      A,(HL)
        EXX
        LD      E,A
        LD      D,0
        LD      HL,TEFF
        ADD     HL,DE
        EXX
        LD      L,A
        LD      H,0
        LD      A,(DE)
        LD      C,A
        INC     DE
        LD      A,(DE)
        LD      B,A
        ADD     HL,BC
        EX      DE,HL
        LD      L,(IX+2)
        LD      H,(IX+3)
        LD      B,3
EFA2    LD      C,4
EFA3    LD      A,(HL)
        EXX
        AND     (HL)
        INC     HL
        EXX
        LD      (HL),A
        LD      A,(DE)
        OR      (HL)
        LD      (HL),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,EFA3
        DJNZ    EFA4
        JR      EFA1
EFA4    PUSH    DE
        LD      DE,60
        ADD     HL,DE
        POP     DE
        JR      EFA2
EFA1    LD      DE,8
        ADD     IX,DE
        POP     BC
        DJNZ    EFA0
        RET
DBONUS  LD      HL,TBON
        LD      DE,SCR+64+26
        LD      B,8
DBO0    LD      A,(HL)
        CALL    DISA
        INC     DE
        INC     HL
        DJNZ    DBO0
        LD      HL,BONUS
        LD      DE,SCR+64+34
        LD      BC,600H
DBO1    LD      A,(HL)
        CP      '0'
        JR      NZ,DBO2
        LD      A,C
        OR      A
        DEC     DE
        JR      Z,DBO3
        INC     DE
        LD      A,'0'
DBO2    CALL    DISA
        LD      C,1
DBO3    INC     DE
        INC     HL
        DJNZ    DBO1
        LD      A,C
        OR      A
        RET     NZ
        LD      A,'0'
        CALL    DISA
        RET
TBON    DEFM    'BONUS : '
DIG     LD      A,(BASE)
        CP      1
        RET     NZ
        LD      A,(BADIG)
        OR      A
        JP      NZ,CREUX
        LD      A,(DEMO)
        OR      A
        JR      NZ,DIG0
        LD      A,(3840H)
        AND     80H
        JR      NZ,DIG0
        IN      A,(0)
        CPL
        AND     10H
        JR      NZ,DIG0
        IN      A,(0)
        CPL
        AND     3
        CP      3
        RET     NZ
DIG0    LD      A,(BADEC)
        OR      A
        RET     NZ
        LD      A,(BAY)
        CP      4
        RET     Z
        LD      A,(BAX)
        LD      (X),A
        LD      A,(BAY)
        OR      A
        JR      Z,DIG1
        DEC     A
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        RET     NZ
DIG1    LD      A,(BAY)
        LD      (Y),A
        CALL    CASE
        BIT     3,(HL)
        RET     NZ
        LD      A,(HL)
        AND     7
        CP      4
        JR      NZ,DIG2
        LD      IX,TALIEN
        LD      B,8
DIG3    LD      A,(IX)
        AND     0FCH
        JR      Z,DIG4
        BIT     2,A
        JR      NZ,DIG4
        LD      A,(BAX)
        CP      (IX+5)
        JR      NZ,DIG4
        LD      A,(BAY)
        CP      (IX+6)
        JR      Z,DIG2
DIG4    LD      DE,8
        ADD     IX,DE
        DJNZ    DIG3
        RET
DIG2    LD      A,(FTROU)
        OR      A
        RET     NZ
        LD      A,1
        LD      (BADIG),A
        LD      (FTROU),A
        RET
CREUX   LD      A,(BADIG)
        CP      6
        RET     Z
        LD      A,(ALTA)
        AND     1
        RET     Z
        LD      A,(BADEC)
        OR      A
        JR      NZ,CRU
        LD      A,(DEMO)
        OR      A
        JP      NZ,MVU1
        LD      A,(3840H)
        AND     80H
        JP      NZ,MVU1
        IN      A,(0)
        CPL
        AND     10H
        JP      NZ,MVU1
        IN      A,(0)
        CPL
        AND     3
        CP      3
        JP      Z,MVU1
        JR      CRX
CRU     CALL    MVD1
        CALL    SONH1
        LD      A,(BAX)
        LD      (X),A
        LD      A,(BAY)
        LD      (Y),A
        CALL    CASE
        LD      A,(HL)
        AND     7
        CP      4
        JR      Z,CRE0
        INC     A
        LD      (HL),A
        CP      4
        RET     NZ
CRX     XOR     A
        LD      (BADIG),A
        RET
CRE0    LD      IX,TALIEN
        LD      B,8
CRE1    LD      A,(IX)
        AND     0FCH
        JR      Z,CRE2
        BIT     2,A
        JR      NZ,CRE2
        LD      A,(BAX)
        CP      (IX+5)
        JR      NZ,CRE2
        LD      A,(BAY)
        CP      (IX+6)
        JR      Z,CRE3
CRE2    LD      DE,8
        ADD     IX,DE
        DJNZ    CRE1
        JR      CRX
CRE3    LD      A,(BADIG)
        INC     A
        LD      (BADIG),A
        CP      6
        RET     NZ
        LD      B,0CH
        LD      A,(IX+7)
        OR      A
        JR      NZ,CRZ
        LD      B,4
CRZ     LD      A,(IX)
        AND     3
        OR      B
        LD      (IX),A
        LD      (IX+4),2
        LD      HL,MOVIN
        INC     (HL)
        JR      CRX
SONH1   LD      C,8
NH1     LD      A,1
        OUT     (255),A
        LD      B,90
        DJNZ    $
        XOR     A
        OUT     (255),A
        LD      B,70
        DJNZ    $
        DEC     C
        JR      NZ,NH1
        RET
EXP     LD      A,(BASE)
        CP      2
        RET     NZ
        LD      A,3
        LD      (BASE),A
        CALL    SONH5
        LD      BC,0
        CALL    PAUSE
        LD      A,(PLAY)
        CP      1
        JR      NZ,EXP1
        LD      A,(SHP1)
        JR      EXP2
EXP1    LD      A,(SHP2)
EXP2    OR      A
        JP      Z,MUSIC
        RET
SONH5   LD      L,1
EXP0    LD      A,1
        OUT     (255),A
        LD      B,L
        DJNZ    $
        XOR     A
        OUT     (255),A
        LD      B,L
        DJNZ    $
        INC     L
        JR      NZ,EXP0
        RET
        INCLUDE VOICE1
        DEFM    '--( APPLE PANIC IS THE 5TH '
        DEFM    'PROGRAM OF Y. LEMPEREUR )--'
        COND    0!(TYPE=DISK)!(TYPE=PROT)
        END     DEBUT
        ENDC
        COND    TYPE=TAPE
        ORG     4321H
        JP      DEBUT
        END     CLEAN
        ENDC
