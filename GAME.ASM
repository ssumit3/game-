        .MODEL SMALL
        .STACK 190
        .DATA
        STR DB 'ENTER NO OF COLMNS $'
        STR2 DB 'ENTER NO OF COLMNS $'
        WINSTR DB 'YOU WON SABASSH!!! $'
        WINF DB 0
        SPS DB '  $'
        SPS2 DB '   $'
        TOTCOL DB ?
        TOTROW DB ?
        FIRST1 DB 0A9H,' ','$'
        FIRST2 DB 0C2H,' ','$'
        MID DB 0C4H,' ','$'
        LAST DB 0BFH,' ','$'
        BOT11 DB 0C3H,' ','$'
        BOT12 DB 0C5H,' ','$'
        BOT13 DB 0B4H,' ','$'
        BOT21 DB 0C0H,' ','$'
        BOT22 DB 0C1H,' ','$'
        BOT23 DB 0D9H,' ','$'

        VERTICALLINE DB 0B3H,' ','$'
        NO DB  0
        LSTNO DB ?
        CURROW DB 03H
        CURCOL DB 28H
        INIROW DB 03H
        INICOL DB 28H
        CURX DB ?
        CURY DB ?
        NEXTX DB ?
        NEXTY DB ?
        STACKNO DW 00
        .CODE
        
        MAIN PROC NEAR
        MOV AX,@DATA
        MOV DS,AX
        MOV AH,09H
        CALL CLRSCN
        MOV DX,0000H
        CALL SETCRSR
        LEA DX,STR
        INT 21H
        MOV AH,10H
        INT 16H
        PUSH AX
        MOV AH,09H
        LEA DX,STR2
        INT 21H
        MOV AH,10H
        INT 16H
        SUB AL,30H
        MOV TOTCOL,AL
        MOV CURY,AL
        DEC CURY
        POP AX
        CALL CLRSCN
        MOV DH,CURROW
        MOV DL,CURCOL
        CALL SETCRSR
        SUB AL,30H
        MOV CH,00H
        MOV CL,AL
        MOV TOTROW,AL
        MOV CURX,AL
        DEC CURX
        CALL FINDLASTNO
        CALL DISPBOX
        CALL LOADDX
        CALL SETCRSR
       ; MOV AH,10H
        ;INT 16H
        CALL ACCEPTARROW
        MOV DX,00
        MOV AX,4C00H
        INT 21H
        MAIN ENDP

        ACCEPTARROW PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV AX,00
        MOV AL,LSTNO
        MOV CH,00
        MOV CL,LSTNO
        INC CL
        AS1:
               ; CMP AL,LSTNO
               ; JE AS2
                PUSH AX
                DEC AL
              LOOP AS1
               ; JMP AS1
               ; AS2:
        AA1:
                MOV AH,10H
                INT 16H
                CMP AH,48H  ;UP
                JNE  UP1
                JMP  AA2
                UP1:
                CMP AH,50H  ;DN
                JNE DN1
                JMP AA3
                DN1:
                CMP AH,4BH  ;LT
                JNE LT1
                JMP AA4
                LT1:
                CMP AH,4DH  ;RT
                JNE RT1
                JMP AA5
                RT1:
                CMP AL,1BH  ;ESC KEY
                JNE  ES1
                JMP AA7
                ES1:
                JMP AA1
                AA2:
                       MOV BL,CURX
                       CMP BL,00
                       JA TA1
                       MOV BL,TOTROW
                       TA1:
                           DEC BL
                           MOV NEXTX,BL
                       MOV BL,CURY
                       MOV NEXTY,BL
                       CALL GETNO
                       CALL SHOWNO
                       MOV BL,NEXTX
                       MOV CURX,BL
                       CALL LOADDX
                       CALL SETCRSR
                       CALL DISPSPS
                       CALL SETCRSR
                       MOV DX,00
                       JMP AA6

                AA3:
                       MOV BL,CURX
                       MOV CL,TOTROW
                       DEC CL
                       CMP BL,CL
                       JNE TD1
                       MOV BL,0
                       JMP  TD2
                       TD1:
                           INC BL
                       TD2:
                           MOV NEXTX,BL
                       MOV BL,CURY
                       MOV NEXTY,BL
                       CALL GETNO
                       CALL SHOWNO
                       MOV BL,NEXTX
                       MOV CURX,BL
                       CALL LOADDX
                       CALL SETCRSR
                       CALL DISPSPS
                       CALL SETCRSR
                       MOV DX,00
                       JMP AA6
                        
                AA4:
                       MOV BL,CURY
                       CMP BL,00
                       JA TL1
                       MOV BL,TOTCOL
                       TL1:
                           DEC BL
                           MOV NEXTY,BL
                       MOV BL,CURX
                       MOV NEXTX,BL
                       CALL GETNO
                       CALL SHOWNO
                       MOV BL,NEXTY
                       MOV CURY,BL
                       CALL LOADDX
                       CALL SETCRSR
                       CALL DISPSPS
                       CALL SETCRSR
                       MOV DX,00
                       JMP AA6

                        
                AA5:
                       MOV BL,CURY
                       MOV CL,TOTCOL
                       DEC CL
                       CMP BL,CL
                       JNE TR1
                       MOV BL,0
                       JMP  TR2
                       TR1:
                           INC BL
                       TR2:
                           MOV NEXTY,BL
                       MOV BL,CURX
                       MOV NEXTX,BL
                       CALL GETNO
                       CALL SHOWNO
                       MOV BL,NEXTY
                       MOV CURY,BL
                       CALL LOADDX
                       CALL SETCRSR
                       CALL DISPSPS
                       CALL SETCRSR
                       MOV DX,00
                        
                AA6:
                  MOV BH,WINF
                  CMP BH,00
                  JE NF1
                  CALL WINFUNCTION
                  JMP   AA7
                  NF1:
                 JMP AA1
                AA7:

        MOV CH,00
        MOV CL,LSTNO
        INC CX
          AA8:
                POP AX
                LOOP AA8
       ; POP BP
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        ACCEPTARROW  ENDP
        WINFUNCTION PROC NEAR
        MOV DX,011EH
        CALL SETCRSR
        LEA DX,WINSTR
        MOV AH,09H
        INT 21H
        MOV DX,00
        RET
        WINFUNCTION ENDP
        DISPSPS PROC NEAR
        PUSH AX
        PUSH DX
        MOV AH,09H
        LEA DX,SPS2
        INT 21H
        POP DX
        POP AX
        RET
        DISPSPS ENDP
        GETNO PROC NEAR
        PUSH CX
        PUSH SI
        PUSH DI
        PUSH BX
        PUSH AX
        PUSH BP
        MOV BP,SP
        MOV CH,00
        MOV CL,NEXTX
        MOV SI,14
        MOV AH,00
        MOV AL,TOTCOL
        G1:
                ADD SI,AX
                ADD SI,AX
                LOOP G1
        MOV CL,NEXTY
        ADD SI,CX
        ADD SI,CX
        ;INC SI
        MOV AX,[BP+SI]
        MOV CH,00
        MOV CL,CURX
        MOV DI,14
        MOV BH,00
        MOV BL,TOTCOL
        G2:
                ADD DI,BX
                ADD DI,BX
                LOOP G2
        MOV CL,CURY
        ADD DI,CX
        ADD DI,CX
        ;INC SI
        MOV BX,[BP+DI]
        MOV [BP+SI],BX
        MOV [BP+DI],AX
        MOV NO,AL
        MOV SI,14
        MOV AX,[BP+SI]
        ADD SI,02
        MOV BX,[BP+SI]
        MOV CH,00
        MOV CL,LSTNO
        WN1 :
                CMP AX,BX
                JB WN2
                ADD SI,02
                MOV AX,BX
                MOV BX,[BP+SI]
                LOOP WN1
        WN2 :
                CMP CX,00
                JNE WN3
                MOV WINF,1
        WN3:
        POP BP
        POP AX
        POP BX
        POP DI
        POP SI
        POP CX
        RET
        GETNO ENDP
        LOADDX PROC NEAR
        PUSH CX
        MOV DH,INIROW
        MOV DL,INICOL
        MOV CH,00
        MOV CL,CURX
        LD1:
                ADD DH,02
                LOOP LD1
                INC DH
        MOV CL,CURY
        LD2:
                ADD DL,04
                LOOP LD2
                INC DL
        POP CX
        LOADDX ENDP
        FINDLASTNO  PROC NEAR
        PUSH CX
        PUSH AX
        MOV CH,00
        MOV CL,TOTCOL
        MOV AX,0000
        NO1:
                ADD AL,TOTROW
                LOOP NO1
         DEC AL
         MOV LSTNO,AL
         POP AX
         POP CX
         RET
         FINDLASTNO ENDP

        DISPBOX PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV CL,TOTROW
        MOV CH,00H
        MOV BX,CX
        DB1:
                PUSH CX
                PUSH BX
                CMP CX,BX
                JNE DB2
                MOV CH,00H
                MOV CL,TOTCOL
                MOV BX,CX
                CALL ROWTOP
                JMP DB3
                DB2:
                MOV CH,00H
                MOV CL,TOTCOL
                MOV BX,CX
                CALL ROWBOT1
                DB3:
                MOV DH,CURROW
                INC DH
                MOV CURROW,DH
                MOV DL,CURCOL
                CALL SETCRSR
                CALL DISPNO
                INC DH
                MOV CURROW,DH
                CALL SETCRSR
                POP BX
                POP CX
                LOOP DB1
                MOV CH,00H
                MOV CL,TOTCOL
                MOV BX,CX
                
                CALL ROWBOT2

        POP DX
        POP CX
        POP BX
        POP AX
        RET
        DISPBOX  ENDP

        ROWBOT1 PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV BX,CX
        MOV AH,09H
        R1:
                CMP CX,BX
                JNE R2
                LEA DX,BOT11
                JMP R3
                R2:
                 LEA DX,BOT12
                R3:
                INT 21H
                LEA DX,MID
                INT 21H
                LOOP R1
           LEA DX,BOT13
           INT 21H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        ROWBOT1  ENDP
        ROWBOT2 PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV BX,CX
        MOV AH,09H
        R21:
                CMP CX,BX
                JNE R22
                LEA DX,BOT21
                JMP R23
                R22:
                 LEA DX,BOT22
                R23:
                INT 21H
                LEA DX,MID
                INT 21H
                LOOP R21
           LEA DX,BOT23
           INT 21H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        ROWBOT2  ENDP


        DISPNO PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        LEA SI,NO
        MOV AH,09H
        D1:
                LEA DX,VERTICALLINE
                INT 21H
                CALL SHOWNO
               ; MOV DX,SI
                ;INT 21H
                INC BYTE PTR [SI]
                LOOP D1
           LEA DX,VERTICALLINE
           INT 21H

        POP DX
        POP CX
        POP BX
        POP AX
        RET
        DISPNO  ENDP
        SHOWNO PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV AH,NO
        CMP AH,LSTNO
        JNE S7
        LEA DX,SPS
        MOV AH,09H
        INT 21H
        JMP S4
        S7:   
         MOV BH,00
         MOV DL,'0'
         ;MOV AH,NO
         S1:
                CMP AH,10
                JB S2
                SUB AH,10
                INC DL
                JMP S1
          S2:
                MOV BL,'0'
                S5:
                    CMP AH,00
                    JE S6
                    DEC AH
                    INC BL
                    JMP S5
                S6:
          CMP DL,'0'
          JE S3
          INC BH
          MOV AH,02H
        ;  ADD DL,30
          INT 21H
          S3:
          MOV DL,BL
         ; ADD DL,30
          MOV AH,02H
          INT 21H
          CMP BH,00
          JNE S4
          MOV DL,' '
          MOV AH,02H
          INT 21H
          S4:
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        SHOWNO  ENDP


        ROWTOP PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV AH,09H
        L1:
                CMP CX,BX
                JNE L2
                LEA DX,FIRST1
                JMP L3
                L2:
                LEA DX,FIRST2
                L3:
                INT 21H
                LEA DX,MID
                INT 21H
                LOOP L1
           LEA DX,LAST
           INT 21H

        POP DX
        POP CX
        POP BX
        POP AX
        RET
        ROWTOP  ENDP

        CLRSCN PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV AX,0600H
        MOV BH,30H
        MOV CX,0000H
        MOV DX,184FH
        INT 10H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        CLRSCN  ENDP
        SETCRSR PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV AH,02H
        MOV BH,00H
        INT 10H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        SETCRSR  ENDP
        END MAIN
