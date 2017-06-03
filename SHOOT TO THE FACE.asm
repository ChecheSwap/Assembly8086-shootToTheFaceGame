;NOTES: #IF YOU RECIBED <DIRECTORY ALREADY EXIST> IT IS NORMAL DO NOT WORRY, #FILE OPERATION: ALL SCORES WHITH THE LAST NAME IN THE FIRST AREA OF A VECTOR INITIALIZER
;@CHECHESWAP

MACRO SAVE_IN_FILE DIR , FILE, STR1, STR2, STR2_LENGTH
    
    PUSHA
        
        LEA DX, DIR
        MOV AH, 39H
        INT 21H      
        
        MOV AH, 3CH
        MOV CX, 0
        LEA DX, TFILE
        INT 21H
        MOV HANDLE, AX  
        
        
        MOV AH, 40H
        MOV BX, HANDLE        
        LEA DX, STR2
        MOV CX, STR2_LENGTH
        INT 21H  
        
        MOV AH, 42H
        MOV BX, HANDLE
        MOV AL, 02H
        MOV CX, 0D
        MOV DX, 2H
        INT 21H
        
        MOV AH, 40H
        MOV BX, HANDLE        
        LEA DX, STR1
        MOV CX, 18D
        INT 21H 
        
        MOV AH, 3EH
        MOV BX, HANDLE
        INT 21H
       
    
    POPA    
  
SAVE_IN_FILE ENDM 


MACRO GETSTRING DESTINATION
    
    PUSHA
        
        MOV AH, 0AH
        LEA DX, DESTINATION
        INT 21H
    
    POPA
    
GETSTRING ENDM

MACRO SET_POSITION ROW COL
    
    PUSHA
    
        MOV AH, 02H
        MOV BH, 00H
        MOV DH, ROW
        MOV DL, COL
        INT 10H
    
    POPA
        
    
SET_POSITION ENDM


MACRO SOUND 
 
    PUSHA
    
        MOV AH,02
        MOV DX,07D
        INT 21H
    
    POPA
    
SOUND ENDM

MACRO NEWL
    
    PUSHA
    
        MOV AH, 02H
        MOV DL, 0AH
        INT 21H  
        
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
    
    POPA    

NEWL ENDM  

MACRO ENDL
    
    PUSHA
    
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
    
    POPA

ENDL ENDM  

MACRO PRINT STMT

    PUSHA
    
        MOV AH, 09H
        LEA DX, STMT
        INT 21H
    
    POPA
    
    
PRINT ENDM


.MODEL LARGE      


.DATA 

MY_ATRIB  DB 10011111B 
 
PL_ATTRIB DB 10011110B

BL_ATTRIB DB 10011010B   

AR_ATTRIB DB 10010000B

PL_CHAR DB 3EH  

BL_CHAR DB 02H

AR_CHAR DB 0F0H

       
MNU_STR DW 0DH
        DW "          * *                                                    * *",0AH,0DH
        DW "           *                                                      * ",0AH,0DH
        DW "          * *                                                    * *",0AH,0DH
        DW "             ****************************************************",0AH,0DH
        DW "             *                                                  *",0AH,0DH                                        
        DW "             *            ~Proyecto Basico en .ASM86            *",0AH,0DH
        DW "             *                                                  *",0AH,0DH
        DW "             ****************************************************",0AH,0DH
        DW "             *                                                  *",0AH,0DH
        DW "             *              >>>Shoot to the face<<<             *",0AH,0DH
        DW "             *                                                  *",0AH,0DH          
        DW "             *    @Flecha Arriba y Abajo para mover Jugador     *",0AH,0DH
        DW "             *    @Tecla Espacio Para Disparar                  *",0AH,0DH
        DW "             *    @Enter Para Iniciar                           *",0AH,0DH
        DW "             *                                                  *",0AH,0DH 
        DW "             *                                                  *",0AH,0DH
        DW "             *       #Code By: Jesus Jose Navarrete Baca        *",0AH,0DH
        DW "             ****************************************************",0AH,0DH
        DW "          * *                                                    * *",0AH,0DH
        DW "           *                                                      * ",0AH,0DH
        DW "          * *                                                    * *",0AH,0DH

DW "$",0AH,0DH   

FACE_POS DW 3860D       

FACE_STATUS DB 0H

MAX DW 5D
                                            
                                            
DIRECTION DB 0D

STATE_STRING DB ">>>>>>>>>>>>>>>>>>$"
  

GAME_OVER_STR DW " ",0AH,0DH
DW "                             *                *",0AH,0DH
DW "                             ******************",0AH,0DH
DW "                             *  -Puntuacion-  *",0AH,0DH
DW "                             ******************",0AH,0DH
DW " ",0AH,0DH
DW " ",0AH,0DH
DW " ",0AH,0DH
DW " ",0AH,0DH
DW " ",0AH,0DH
DW " ",0AH,0DH
DW "                             >>Fin del Juego<<",0AH,0DH
DW "                    @Presione Enter Para Jugar de Nuevo$",0AH,0DH

  
EXIT DB 0H     

PLAYER_POS DW 1760D                         

ARR_POS DW 0H                             

ARR_ST DB 0H                          

ARR_LIMIT DW  22D     
     
HIT_NUM DB 0D

GAIN DW 0D

LOSE DW 0D  

TDIR DB "c:\Shoot to the face",0   

TFILE DB "c:\Shoot to the face\Record_Score.txt",0

NAME_STRING DW 30,0,30 DUP(?)                 

HANDLE DW ?

INIT_STRING DB "->Ingrese Nombre de Jugador:$"


.STACK

    DW 512 DUP(?)    

.CODE

MAIN PROC     
    
    MOV AX,@DATA
    
    MOV DS,AX
    
    MOV AX, 0B800H
    MOV ES, AX 
        
    
    JMP MENU_GAME                             
    
                                                                       
    TMAIN:                                 
                                               
        MOV AH, 01H
        INT 16H
                                                                                
        JNZ KEY_PRESS    
                                      
        
        TH_1:                                  
                      
            MOV AX,[MAX]
        
            CMP LOSE,AX 
                                  
            JGE GAME_OVER
            
            MOV DX, [ARR_POS]                   
            CMP DX, [FACE_POS]
            JE HIT
            
            CMP [DIRECTION], 8D                   
            JE  PL_UP
            CMP [DIRECTION], 2D                   
            JE  PL_DOWN
            
            MOV DX, ARR_LIMIT                  
            CMP ARR_POS, DX
            JGE HIDE_ARROW
            
            CMP FACE_POS, 0D                   
            JLE MISS_LOON
            JNE RENDER_LOON
        
            
            HIT:                              
                SOUND
                
                INC GAIN                       
                
                
                CALL SEE_SCORE 
                
                PRINT STATE_STRING
                
                ENDL
                
                JMP FIRE                  
        
            RENDER_LOON:  
                                                        
                             
                MOV CH, [BL_ATTRIB]
                
                MOV CL, 031D
            
                MOV BX, [FACE_POS]    
                
                MOV ES:[BX],CX            
                    
                SUB [FACE_POS],160D    
                          
                MOV CL, [BL_CHAR]
                MOV CH, [BL_ATTRIB]
            
                MOV BX, [FACE_POS]
                MOV ES:[BX], CX
                
                CMP ARR_ST,1D 
                           
                JE  RENDER_ARROW
                
                JNE INS_C2 
            
            RENDER_ARROW:                      
            
                MOV CL, 031D
                
                MOV CH, [AR_ATTRIB]
            
                MOV BX, ARR_POS
                MOV ES:[BX],CX
                    
                ADD ARR_POS, 4D  
                             
                MOV CL, [AR_CHAR]
                MOV CH, [AR_ATTRIB]
            
                MOV BX, ARR_POS 
                MOV ES:[BX],CX
            
            INS_C2:
                
                MOV CL, [PL_CHAR]                  
                MOV CH, [PL_ATTRIB]
                
                MOV BX,PLAYER_POS  
                
                MOV ES:[BX], CX
                
                 
                           
        CMP EXIT, 0D
        JE TMAIN
                                  
        JMP EXIT_ALL
    
        
    PL_UP:
                                    
        MOV CL, 031D
        
        MOV CH,[PL_ATTRIB]            
        
        MOV BX,[PLAYER_POS]
        
        MOV ES:[BX],CX
        
        SUB PLAYER_POS, 160D                  
        
        MOV DIRECTION, 0      
        
        JMP INS_C2                      
        
    PL_DOWN:
    
        MOV CL, 031D
                               
        MOV CH,[PL_ATTRIB]                         
                                              
        MOV BX,PLAYER_POS 
        
        MOV ES:[BX], CX
        
        ADD PLAYER_POS,160D   
                        
        MOV DIRECTION, 0H
        
        JMP INS_C2
    
    KEY_PRESS:                              
        
        MOV AH,0H
        INT 16H
    
        CMP AH,48H                            
        JE UP_KEY
        
        CMP AH,50H
        JE DOWN_KEY
        
        CMP AH, 39H                           
        JE SPACE_KEY
        
        CMP AH,4BH                            
        JE LEFT_KEY         
                                             
        JMP TH_1
    
    LEFT_KEY:                                  
        
        INC LOSE
                
        CALL SEE_SCORE 
        
        PRINT STATE_STRING
        
        ENDL       
        
    JMP TH_1
        
    UP_KEY:                                    
        MOV [DIRECTION], 8D
        
        JMP TH_1
    
    DOWN_KEY:
        MOV [DIRECTION], 2D                     
        JMP TH_1
        
    SPACE_KEY:                                 
        CMP ARR_ST,0D
        JE  FIRE_ARROW
        JMP TH_1
    
    FIRE_ARROW:                               
        MOV DX, PLAYER_POS                    
        MOV ARR_POS, DX
        
        MOV DX, PLAYER_POS                     
        MOV ARR_LIMIT, DX                   
        ADD ARR_LIMIT, 22D  
        
        MOV ARR_ST, 1D                  
        JMP TH_1                      
    
    MISS_LOON:
        
        INC LOSE                           
                              
        CALL SEE_SCORE 
        
        PRINT STATE_STRING
                                              
        ENDL
    
        
    FIRE:                                
        MOV FACE_STATUS, 1D
        MOV FACE_POS, 3860D     
        JMP RENDER_LOON
        
    HIDE_ARROW:
        MOV ARR_ST, 0H                   
        
        MOV CL, ' '
        MOV CH, [AR_ATTRIB]
        
        MOV BX, [ARR_POS]     
        MOV ES:[BX],CX
        
        CMP FACE_POS, 0D
        JLE MISS_LOON
        JNE RENDER_LOON 
        
        JMP INS_C2
                                              
    GAME_OVER:
                               
        CALL CLS
                                                        
            
        PRINT STATE_STRING
        
        PRINT GAME_OVER_STR
        
        SAVE_IN_FILE TDIR,TFILE, STATE_STRING, NAME_STRING, 30
                                 
        MOV LOSE, 0D
        MOV GAIN, 0D
        
        MOV PLAYER_POS, 1760D
    
        MOV ARR_POS,0D
        MOV ARR_ST, 0D
        MOV ARR_LIMIT, 22D      
    
        MOV FACE_POS,3860D       
        MOV FACE_STATUS,0D
             
        MOV DIRECTION, 0D
               
                                               
        INP1:
            MOV AH, 01H
            INT 21H
            CMP AL, 13D
            JNE INP1            
                        
            JMP INP2
        
    
    MENU_GAME:   
        
        CALL CLS
                                              
                                               
        PRINT MNU_STR      
        
        NEWL
        
        PRINT INIT_STRING                 
              
        GETSTRING NAME_STRING
                                               
        INP2:         
            
            CALL CLS 
                        
                                          
            CALL SEE_SCORE                 
            
            PRINT STATE_STRING
        
            ENDL      
                        
            
            JMP TMAIN
    
    
    EXIT_ALL:                                  
    
    MOV EXIT,33D
    
    MAIN ENDP
    

    
    SEE_SCORE PROC
        
        LEA SI, STATE_STRING
        
        MOV DX, [GAIN]
        ADD DX, 48D
        
        MOV [SI]  , 9D
        MOV [SI+1], 9D      
        MOV [SI+2], 9D        
        MOV [SI+3], 9D
        MOV [SI+4], '-'
        MOV [SI+5], '-'                                        
        MOV [SI+6], '>'
        MOV [SI+7], 'A'
        MOV [SI+8], ':'
        MOV [SI+9], DX
        
        MOV DX, [LOSE]
        ADD DX, 48D
        
        MOV [SI+10], ' '
        MOV [SI+11], '-'
        MOV [SI+12], '-'
        MOV [SI+13], '>'
        MOV [SI+14], 'P'
        MOV [SI+15], ':'
        MOV [SI+16], DX
        
        RET   
    
    SEE_SCORE ENDP
    
    CLS PROC NEAR
        
        MOV AH, 06H    
        XOR AL, AL	   
        XOR CX, CX	   
        MOV DX, 4F4FH  
        MOV BH, [MY_ATRIB]        	 
        INT 10H  		
    		
        MOV AH, 02H
        MOV DH, 0H
        MOV DL, 0H
        MOV BH, 00H 
        INT 10H 
        
        RET
    CLS ENDP

END MAIN