//=========================================================================== 
// Trigger: aa
//=========================================================================== 
function InitTrig_aa takes nothing returns nothing
set gg_trg_aa=CreateTrigger()
call TriggerAddAction(gg_trg_aa,function Trig_aa_Actions)
endfunction

function Trig_aa_Actions takes nothing returns nothing
local integer id=GetPlayerId(GetTriggerPlayer())
local integer stock
set udg_PLAY_NUM=(udg_PLAY_NUM+1)
set udg_s[GetConvertedPlayerId(GetTriggerPlayer())]=IniReadString((udg_War3Path[GetPlayerId(GetTriggerPlayer())]+udg_FileName),("Hero"+udg_File[GetPlayerId(GetTriggerPlayer())]),"Date","",GetPlayerId(GetTriggerPlayer()),GetPlayerId(GetLocalPlayer()))
set stock=S2I(IniReadString(udg_War3Path[id]+udg_FileName,"Hero"+udg_File[id],"DateStock","",id,GetPlayerId(GetLocalPlayer())))
if udg_s[GetPlayerId(GetTriggerPlayer())+1]==null or udg_s[GetPlayerId(GetTriggerPlayer())+1]=="" then
set udg_s[GetPlayerId(GetTriggerPlayer())+1]="a"
endif
call StoreInteger(udg_Cache,I2S(id),"Stock1",stock)
call StoreInteger(udg_Cache,I2S(id),"Stock2",GetFingerMark(udg_s[id+1],51687788))
if GetTriggerPlayer()==GetLocalPlayer()then
call SyncStoredInteger(udg_Cache,I2S(id),"Stock1")
call SyncStoredInteger(udg_Cache,I2S(id),"Stock2")
endif
call TriggerSleepAction(2.0)
if GetStoredInteger(udg_Cache,I2S(id),"Stock1")!=GetStoredInteger(udg_Cache,I2S(id),"Stock2")then
call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.52,-1.00,60.0,"|cffffcc00存档验证出错!|r")
return
endif
set udg_s[GetPlayerId(GetTriggerPlayer())+1]=DecodeString(udg_s[GetPlayerId(GetTriggerPlayer())+1])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=(StringLength(udg_s[GetConvertedPlayerId(GetTriggerPlayer())])-1)
set udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))]=0
loop
exitwhen udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))]>udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
if(Trig_aa_Func022Func001C())then
set udg_s[(12+GetConvertedPlayerId(GetTriggerPlayer()))]=SubString(udg_s[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[(24+GetConvertedPlayerId(GetTriggerPlayer()))],udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))])
set udg_pid[(24+GetConvertedPlayerId(GetTriggerPlayer()))]=(udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))]+1)
set udg_pid[(36+GetConvertedPlayerId(GetTriggerPlayer()))]=(udg_pid[(36+GetConvertedPlayerId(GetTriggerPlayer()))]+1)
set udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+udg_pid[(36+GetConvertedPlayerId(GetTriggerPlayer()))])]=S2I(udg_s[(12+GetConvertedPlayerId(GetTriggerPlayer()))])
else
endif
set udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))]=udg_pid[(12+GetConvertedPlayerId(GetTriggerPlayer()))]+1
endloop
call StoreIntegerBJ(udg_pid[(36+GetConvertedPlayerId(GetTriggerPlayer()))],I2S(GetConvertedPlayerId(GetTriggerPlayer())),"id",udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+1)],"Type",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+2)],"Lv",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+3)],"exp",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+4)],"SKILL1",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+5)],"SKILL2",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+6)],"SKILL3",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+7)],"SKILL4",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+8)],"SKILL5",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+9)],"SKILL6",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+10)],"SKILL7",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+11)],"gold",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+12)],"wood",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+13)],"EXPJX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+14)],"EXPDX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+15)],"EXPFX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+16)],"EXPGX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+17)],"EXPQX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+18)],"EXPZHIZAO",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+19)],"JXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+20)],"DXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+21)],"FXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+22)],"GXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+23)],"QXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+24)],"ZHIZAOLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(25+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((25+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(26+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((26+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(27+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((27+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(28+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((28+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(29+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((29+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(30+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((30+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(31+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((31+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(32+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((32+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(33+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((33+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(34+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((34+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(35+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((35+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(36+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((36+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+97)],"ZZ_1",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+98)],"ZZ_0",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+99)],"hero_point",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+100)],"TT_POINT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+101)],"P_STR",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+102)],"P_AGI",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+103)],"P_INT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+104)],"hero_SP_N",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+105)],"lingshou",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+106)],"ZZ_TY",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+107)],"XIA",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+108)],"SL",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+109)],"SLT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+110)],"CH",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+111)],"BB",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+112)],"BB_exp",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+113)],"BB_SKILL",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(114+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item"+I2S((114+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+(115+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))],("item_num"+I2S((115+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+126)],"VOO",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call StoreIntegerBJ(udg_date[((udg_g*GetPlayerId(GetTriggerPlayer()))+127)],"LiQi",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
if(Trig_aa_Func073C())then
call SyncStoredInteger(udg_Cache,"id",I2S(GetConvertedPlayerId(GetTriggerPlayer())))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"Type")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"Lv")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"exp")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL1")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL2")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL3")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL4")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL5")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL6")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SKILL7")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"gold")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"wood")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPJX")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPDX")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPFX")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPGX")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPQX")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"EXPZHIZAO")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"JXLV")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"DXLV")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"FXLV")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"GXLV")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"QXLV")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"ZHIZAOLV")
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((25+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((26+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((27+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((28+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((29+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((30+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((31+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((32+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((33+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((34+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((35+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((36+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"ZZ_1")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"ZZ_0")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"hero_point")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"TT_POINT")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"P_STR")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"P_AGI")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"P_INT")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"hero_SP_N")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"lingshou")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"ZZ_TY")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"XIA")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SL")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"SLT")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"CH")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"BB")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"BB_exp")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"BB_SKILL")
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item"+I2S((114+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),("item_num"+I2S((115+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))))
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"VOO")
call SyncStoredInteger(udg_Cache,(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),"LiQi")
else
endif
call TriggerSleepAction(1.00)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(I2S(GetConvertedPlayerId(GetTriggerPlayer())),"id",udg_Cache)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("Type",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]=CreateUnit(GetTriggerPlayer(),udg_pid[GetConvertedPlayerId(GetTriggerPlayer())],-5010.00,-6303.00,0)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("Lv",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetHeroLevelBJ(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())],false)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("exp",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_EXP_HERO[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],udg_EXP_HERO[GetConvertedPlayerId(GetTriggerPlayer())],false)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL1",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+1]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL2",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+2]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL3",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+3]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL4",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+4]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL5",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+5]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+5)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL6",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+6]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+6)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SKILL7",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_skill[GetPlayerId(GetTriggerPlayer())*7+7]=udg_pid[GetPlayerId(GetTriggerPlayer())+1]
call UnitAddAbilityBJ(udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+7)],udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("gold",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetPlayerStateBJ(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_GOLD,udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_GOLD[GetConvertedPlayerId(GetTriggerPlayer())]=GetPlayerState(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_GOLD)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("wood",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetPlayerStateBJ(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_LUMBER,udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_WOOD[GetConvertedPlayerId(GetTriggerPlayer())]=GetPlayerState(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPJX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_JX_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPDX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_DX_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPFX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_FX_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPGX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_GX_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPQX",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_QX_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("EXPZHIZAO",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_Exp_zhizuo_skill[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("JXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_JX_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("DXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_DX_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("FXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_FX_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("GXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_GX_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("QXLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_QX_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("ZHIZAOLV",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_zhizao_lv[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((25+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_ITEM_BAG_A[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_ITEM_BAG_A[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func006001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((31+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((26+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_ITEM_BAG_B[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_ITEM_BAG_B[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func015001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((32+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((27+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_ITEM_bag[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_ITEM_bag[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func024001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((33+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((28+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func033001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((34+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((29+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_ITEM_BAG_C[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_ITEM_BAG_C[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func042001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((35+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((30+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())]=CreateItem(udg_T,-2903.00,-2303.00)
call UnitAddItem(udg_ITEM_BAG_D[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitDropItemSlot(udg_ITEM_BAG_D[GetConvertedPlayerId(GetTriggerPlayer())],udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_B[GetConvertedPlayerId(GetTriggerPlayer())])
if(Trig_aa_Func135Func051001())then
call RemoveItem(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())])
else
call DoNothing()
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((36+(12*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
call SetItemCharges(udg_getitem[GetConvertedPlayerId(GetTriggerPlayer())],udg_pid[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("ZZ_1",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_ZZ_1[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("ZZ_0",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_ZZ_0[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("hero_point",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("TT_POINT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_TIli_point[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("P_STR",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_P_STR[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,((10*udg_P_STR[GetConvertedPlayerId(GetTriggerPlayer())])+0))
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("P_AGI",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_P_AGI[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,((10*udg_P_AGI[GetConvertedPlayerId(GetTriggerPlayer())])+0))
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("P_INT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_P_INT[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,((10*udg_P_INT[GetConvertedPlayerId(GetTriggerPlayer())])+0))
call TriggerExecute(gg_trg_herotili)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("hero_SP_N",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_hero_SP_N[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("lingshou",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_lingshou[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
call TriggerExecute(gg_trg_herospN)
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("ZZ_TY",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_ZZ_TY[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("XIA",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_XIA[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SL",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_SL[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("SLT",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_SLT[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("CH",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_CH[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("BB",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_BB[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("BB_exp",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_EXP_HERO_BB[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("BB_SKILL",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_BB_SKILL[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=0
loop
exitwhen udg_B[GetConvertedPlayerId(GetTriggerPlayer())]>5
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item"+I2S((114+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_T=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_BB_ITEM[((GetPlayerId(GetTriggerPlayer())*12)+(udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1))]=udg_T
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ(("item_num"+I2S((115+(2*udg_B[GetConvertedPlayerId(GetTriggerPlayer())])))),(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_BB_ITEM_NUM[((GetPlayerId(GetTriggerPlayer())*12)+(udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1))]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_B[GetConvertedPlayerId(GetTriggerPlayer())]=udg_B[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("VOO",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_V_00[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
if(Trig_aa_Func180C())then
call CustomDefeatBJ(GetTriggerPlayer(),"你的角色存档不适合此版本")
else
endif
set udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]=GetStoredIntegerBJ("LiQi",(("Hero"+I2S(GetConvertedPlayerId(GetTriggerPlayer())))+udg_File[GetPlayerId(GetTriggerPlayer())]),udg_Cache)
set udg_LiQi[GetConvertedPlayerId(GetTriggerPlayer())]=udg_pid[GetConvertedPlayerId(GetTriggerPlayer())]
set udg_Save[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,"读取完成")
endfunction