;;; 
;;; MT_TeamSpiritHelper.ahk
;;; 

; SendMode("Input") ;;; 高速モード
; SendMode("Event") ;;; 低速モード

;;; pre setting
DllCall("ChangeWindowMessageFilter", "UInt", 0x233, "UInt", 1) ; WM_DROPFILES
DllCall("ChangeWindowMessageFilter", "UInt", 0x0049, "UInt", 1) ; WM_COPYGLOBALDATA

;;; Static
; AHKDIR := SplitPath(A_ScriptDir,,&test)  ;;; A_ScriptDirの親ディレクトリ
AHKDIR := A_ScriptDir "\"
IMGDIR := AHKDIR "image\MT_TeamSpiritHelper\segment\"
global KINMBASHO_PULDOWN_IMG := [IMGDIR "kinmu_other.png",
						 		IMGDIR "kinmu_other_chk.png",
								]
global TABLE_INDEX_DATE_IMG := [IMGDIR "date_normal.png",
								IMGDIR "date_select.png",
							   ]
global TABLE_ADD_IMG := [IMGDIR "kinmutable_add.png",]
global TABLE_REQUEST_ADD_IMG := [IMGDIR "request_add.png",]

global SAVE_BUTTON_IMG_EN := [IMGDIR "kinmutable_save_point.png",
							IMGDIR "kinmutable_save_enable.png",
						  ]
global SAVE_BUTTON_IMG_DIS := [IMGDIR "kinmutable_save_disable.png",
						]
global SAVE_BUTTON_IMG := SAVE_BUTTON_IMG_EN.Clone()
SAVE_BUTTON_IMG.Push(SAVE_BUTTON_IMG_DIS*)
				
global SAVE_BUTTON_COLOR_EN := [ "0x1B59C9","0x2782ED"]
global SAVE_BUTTON_COLOR_DIS := [ "0xABBACD",]

global ATTEND_IMG := [IMGDIR "attend_weekday.png",
					IMGDIR "attend_weekend1.png",
					IMGDIR "attend_weekend2.png",
					IMGDIR "attend_request.png",
					]
global DIALOG_ATTEND_TOP_IMG := [IMGDIR "dialog_attend_top.png",]
global DIALOG_ATTEND_APPLY_IMG := [IMGDIR "dialog_attend_apply_normal.png",
									IMGDIR "dialog_attend_apply_select.png",
								]
global DIALOG_REST_REMOVE_IMG := [IMGDIR "dialog_rest_remove.png",]
global DIALOG_REST_ADD_IMG := [IMGDIR "dialog_rest_add.png",
							IMGDIR "dialog_rest_add2.png",
							]
global DIALOG_REST_ADD_TRANS := "*Trans0x000000"				
global DIALOG_ATTEND_LINE_IMG := [IMGDIR "dialog_attend_line.png",]

global WORKLOAD_DATE_IMG := [IMGDIR "workload_date_prev.png",]
global WORKLOAD_SETTOP_IMG := [IMGDIR "workload_settop.png",
							IMGDIR "workload_settop_short.png",
							]
global WORKLOAD_JOB_DRAGICON_IMG := [IMGDIR "workload_job_dragicon1.png",
									IMGDIR "workload_job_dragicon2.png",
									]
; global WORKLOAD_ACHIVE_EN_IMG := [IMGDIR "workload_achieve_enable.png",]
global WORKLOAD_KIND_LEFT_IMG := [IMGDIR "workload_kind_left.png",
								IMGDIR "workload_kind_left2.png",
								IMGDIR "workload_kind_left3.png",
								IMGDIR "workload_kind_left4.png",
								]
global WORKLOAD_KIND_RIGHT_IMG := [IMGDIR "workload_kind_right.png",
								IMGDIR "workload_kind_right2.png",
								IMGDIR "workload_kind_right3.png",
								IMGDIR "workload_kind_right4.png",
								]
global WORKLOAD_KIND_INPUT_IMG := [IMGDIR "workload_kind_textbox1.png",
								IMGDIR "workload_kind_textbox2.png",
								; IMGDIR "workload_kind_textbox0.png",
								; IMGDIR "workload_kind_textbox3.png",
								]
global WORKLOAD_KIND_PULLDOWN_IMG := [IMGDIR "workload_kind_pulldown1.png",
									IMGDIR "workload_kind_pulldown2.png",
									]
global WORKLOAD_KIND_PULLDOWN_FIN_IMG := [IMGDIR "workload_kind_pulldown_fin1.png",
										IMGDIR "workload_kind_pulldown_fin2.png",
										]
global WORKLOAD_KIND_LAST_IMG := [IMGDIR "workload_kind_textbox_last1.png",
								IMGDIR "workload_kind_textbox_last2.png",
								; IMGDIR "workload_kind_textbox_last3.png",
								]
global WORKLOAD_KIND_SCALING_IMG := [IMGDIR "workload_kind_scaling1.png",
									IMGDIR "workload_kind_scaling2.png",
									]
global WORKLOAD_KIND_SCALING_TRANS := "*Trans0x000000"

global WORKLOAD_KIND_SELECT_CATEGORY_IMG := [IMGDIR "workload_kind_select_category.png",]
global WORKLOAD_KIND_SELECT_UP_IMG := [IMGDIR "workload_kind_select_up.png",]
global WORKLOAD_KIND_APPLY_IMG := DIALOG_ATTEND_APPLY_IMG

global DIALOG_REQUEST_TOP_IMG := [IMGDIR "dialog_request_top.png",]
global DIALOG_REQUEST_APPLY_IMG := DIALOG_ATTEND_APPLY_IMG
global TABLE_LEFT_IMG := WORKLOAD_KIND_LEFT_IMG



; [1]空白,[2]出社,[3]在宅：客先勤務,[4]在宅：社内業務のみ,[5]その他
;※在宅：客先勤務は選択状態で幅が変わるので必要に応じて修正必要？
; 項目間相対距離
; global KINMBASHO_PULDOWN_REL_YPOS := [0,35,39,47,35]
; ＊その他からの相対距離
global KINMBASHO_PULDOWN_REL_YPOS := [-140,-113,-78,-35,0] ;;[-144,-113,-78,-35,0]


;;;Variable
global STP_SIG := 0
global employ_arr := []
global employ_loaded := 0

;;;Create GUI
MyGui := Gui()
MyGui.OnEvent("Close",CloseApp)
MyGui.OnEvent("DropFiles",Gui_DropFiles)

MyGui.Add("text",,"date start")
MyGui.Add("Edit")
global Sday_num := MyGui.Add("UpDown","vStart Range1-31",1)
MyGui.Add("text",,"date end")
MyGui.Add("Edit")
global Eday_num := MyGui.Add("UpDown","vEnd Range1-31",1)

; MyGui.Add("Radio", "vradiotest", "normal")
; MyGui.Add("Radio", "vradiotest2", "force")
; MyGui.Add("Radio", "vradiotest3", "dry")

; MyGui.Add("CheckBox", "vtesttest", "申請")
; MyGui.Add("CheckBox", "vtesttestte", "勤務時間")
; MyGui.Add("CheckBox", "vtesttesttes", "工数")
; MyGui.Add("CheckBox", "vtesttesttest", "勤務場所etc")
; MyGui.Add("CheckBox", "vtesttesttestt", "勤務時間(申請)")
; MyGui.Add("text",,"Range                    ")
; MyGui.Add("Edit")
; global UPDN_RANGE := MyGui.Add("UpDown","vRange Range1-10000",1)
UsegeText1 := MyGui.Add("text",,"<Usage>")
UsegeText1.GetPos(&UsegeText1X,&UsegeText1Y,&UsegeText1W,&UsegeText1H)
UsegeText2 := MyGui.Add("text","x" UsegeText1X " y" UsegeText1Y+UsegeText1H+5,"F1          : Exec auto input to TeamSpirit")
UsegeText2.GetPos(&UsegeText2X,&UsegeText2Y,&UsegeText2W,&UsegeText2H)
UsegeText3 := MyGui.Add("text","x" UsegeText2X " y" UsegeText2Y+UsegeText2H+5,"Pause      : Process abort.")
UsegeText3.GetPos(&UsegeText3X,&UsegeText3Y,&UsegeText3W,&UsegeText3H)
UsegeText4 := MyGui.Add("text","x" UsegeText3X " y" UsegeText3Y+UsegeText3H+5,"Ctrl + End : This script will be killed.")
UsegeText4.GetPos(&UsegeText4X,&UsegeText4Y,&UsegeText4W,&UsegeText4H)
STATTEXT1 := MyGui.Add("text","w240","<DBG status>")
STATTEXT1.GetPos(&STATTEXT1X,&STATTEXT1Y,&STATTEXT1W,&STATTEXT1H)
global NOWSTAT1 := MyGui.Add("text","x" STATTEXT1X " y" STATTEXT1Y+STATTEXT1H+5 " w240","status")
NOWSTAT1.GetPos(&NOWSTAT1X,&NOWSTAT1Y,&NOWSTAT1W,&NOWSTAT1H)
global NOWSTAT2 := MyGui.Add("text","x" NOWSTAT1X " y" NOWSTAT1Y+NOWSTAT1H+5 " w240","status2")
SB := MyGui.Add("StatusBar",, "Please D&D your employment information.")
;MyGui.Add("Edit")
MyGui.Show

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; macro key
;;;;;;;;;;;;;;;;;;;;;;;;;;

^Esc::
{
	CloseApp
}

F1::
{
	employ_load_chk
	if(employ_loaded = 0){
		return 1
	}
	wait_window_active_tgt
	DaysRange := (Eday_num.Value - Sday_num.Value) + 1
	if(DaysRange <= 0){
		NOWSTAT2.value := "date setting error"
		return 1
	}
	loop DaysRange {
		TMAtnd_top_daily_wrap(Sday_num.Value + (A_index-1))
	}
	NOWSTAT2.value := "TMAtnd_top_daily_wrap end"
	; TMAtnd_top_search_day(&OutX,&OutY,day_num.Value)
	; NOWSTAT2.value := OutX " " OutY
	; TMAtnd_top_request_wrap(9,OutY)
}

; F2::
; {
; 	TMAtnd_dlysmry_workload_date_search(Sday_num.Value)

; 	; TMAtnd_top_search_day(&OutX,&OutY,Sday_num.Value)
; 	; TMAtnd_top_tmsheet_chk(OutY)
; 	; TMAtnd_tmsheet_wrap(9,Sday_num.Value)
; }

; F3::
; {
; 	TMAtnd_dlysmry_workload_input(9,employ_arr[Sday_num.Value][18],employ_arr[Sday_num.Value][19],employ_arr[Sday_num.Value][17])
	
; 	; TMAtnd_top_search_day(&OutX,&OutY,Sday_num.Value)
; 	; TMAtnd_top_dlysmrystat_chk(OutY)
; 	; TMAtnd_dlysmry_wrap(9,Sday_num.Value)
; }

; F4::
; {
; ; 	TMAtnd_top_search_day(&OutX,&OutY,Sday_num.Value)
; ; 	TMAtnd_top_kinmubasho_wrap(9,OutX,OutY,Sday_num.Value)

; 	TMAtnd_tmsheet_wrap(9,Sday_num.Value)

; ;; stat := TMAtnd_top_save_available_chk(OutX,OutY)
; ;; Msgbox stat
; 	; loop 10 {
; 	; 	date := Round(Random(1,31))
; 	; 	NOWSTAT2.value := ""
; 	; 	SB.Settext("lpcnt:" A_index " date:" date)

; 	; 	day_valid := TMAtnd_top_search_day(&OutX,&OutY,date)
; 	; 	if(day_valid = -1) {
; 	; 		NOWSTAT2.value := "SAVE det failed. Abort."
; 	; 		Exit
; 	; 	}
; 	; 	Sleep(300)
; 	; }

; 	; TMAtnd_top_search_day(&OutX,&OutY,Sday_num.Value)
; 	; NOWSTAT1.value := "wait 3sec"
; 	; Sleep(3000)
; 	; NOWSTAT1.value := ""
; 	; TMAtnd_top_search_day(&OutX,&OutY,Sday_num.Value,OutY)
; }

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; function
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; wrapper
TMAtnd_top_daily_wrap(daytgt){
	;;;有効データチェック
	data_valid := DataValidityChk(daytgt)
	if(data_valid = false){
		return 1
	}

	day_valid := TMAtnd_top_search_day(&OutX,&OutY,daytgt)
	if(day_valid = -1) {
		NOWSTAT2.value := "SAVE det failed. Abort."
		Exit
	}
	;申請
	NOWSTAT2.value := OutX " " OutY
	TMAtnd_top_request_wrap(1,OutY)
	TMAtnd_top_wait_loading(1000) ;;申請処理は時間がかかるので長めに待つ
	TMAtnd_top_search_day(&OutX,&OutY,daytgt,OutY)
	;勤務場所etc
	; TMAtnd_top_search_day(&OutX,&OutY,day_num.Value)
	TMAtnd_top_kinmubasho_wrap(1,OutX,OutY,daytgt)
	TMAtnd_top_wait_loading
	; TMAtnd_top_search_day(&OutX,&OutY,daytgt,OutY) ;工数は内部のdate_searchで自動調整するので不要
	;工数
	if(TMAtnd_top_dlysmrystat_chk(OutY) = 0){
		TMAtnd_dlysmry_wrap(1,daytgt)
	}
	TMAtnd_top_wait_loading
	TMAtnd_top_search_day(&OutX,&OutY,daytgt,OutY)
	;出退勤
	if(TMAtnd_top_tmsheet_chk(OutY) = 0){
		TMAtnd_tmsheet_wrap(1,daytgt)
	}
	TMAtnd_top_wait_loading
}


;申請処理
;mode : 1 = normal, 2 = Pseudo, any = debug
TMAtnd_top_request_wrap(mode, Y := unset){
	ret_val := TMAtnd_top_request(Y)
	if(ret_val = 0){
		TMAtnd_request_flex(mode)
	} else {
		NOWSTAT2.value := "wrap stopped"
	}
}

;出退勤処理
TMAtnd_tmsheet_wrap(mode,daytgt){
	;;;TODO：ダイアログの中か外かを判別する処理
	global employ_arr
	restdat := []
	loop 9 {
		if(employ_arr[daytgt][5+(A_index-1)] = ""){
			break
		} else {
			restdat.Push(employ_arr[daytgt][5+(A_index-1)])
		}
	}
	TMAtnd_tmsheet_input(mode,employ_arr[daytgt][3],employ_arr[daytgt][4],restdat*)
}

;工数入力処理
TMAtnd_dlysmry_wrap(mode,daytgt){
	;;;TODO：シングル処理、バースト処理機能
	TMAtnd_dlysmry_workload_date_search(daytgt)
	TMAtnd_dlysmry_workload_input(mode,employ_arr[daytgt][18],employ_arr[daytgt][19],employ_arr[daytgt][17])
}

;勤務場所etc入力処理
TMAtnd_top_kinmubasho_wrap(mode,X,Y,daytgt){
	stat := TMAtnd_top_save_available_chk(X,Y)
	if (stat = true){
		TMAtnd_top_kinmubasho(mode,X,Y,TMAtnd_top_kinmubasho_loc_num(employ_arr[daytgt][14]),employ_arr[daytgt][15],employ_arr[daytgt][16])
	} else {
		NOWSTAT2.value := "SAVE is not available. skip."
	}
}

;;;;;;;;;;;;;;;;;;;;

TMAtnd_dlysmry_workload_pulldown(PosX,PosY,char){ ;;技能、知識の仮入力
	Click(,PosX,PosY)
	Sleep(10)
	SendText char
	Send "{Enter}"
}

TMAtnd_dlysmry_workload_select(AWx,AWy,AWw,AWh){
	; WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A") ;ここで再取得すると稀に画面全体を取得する
	;;;工数内訳セットの検索
	SX := 0
	SY := AWh * 0.0
	EX := AWw * 0.95
	EY := AWh * 0.95
	VARI := "*0" ;"*5"
	detcnt := 0
	loop {
		result := ImageSearchOR(&OutX_1,&OutY_1,SX,SY,EX,EY,VARI,WORKLOAD_KIND_SELECT_CATEGORY_IMG*)
		if (result >= 1) {
			detcnt += 1
			; MouseMove(OutX_1, OutY_1)
			NOWSTAT2.value := OutX_1 " " OutY_1
			if(detcnt > 2){
				break
			}
		} else if(A_index > 20) {
			NOWSTAT2.value := "img not Found"
			return 1
		} else {
			detcnt := 0
		}
		Sleep(10)
	}
	Click(,OutX_1+150+10,OutY_1) ;;;お気に入り選択 150+マージン
	;;; 検索結果のクリック(loadingを兼ねる)
	; ExpColor := "0x1B59C9" ;;ポイント時に色が変わる場合
	ExpColor := "0x2782ED"
	GetColor := 1
	NOWSTAT2.value := "wait expect color"
	loop {
		ExitCodeChk
		Click(,OutX_1+150+10,OutY_1+180) ;;;お気に入り選択 150+マージン
		GetColor := PixelGetColor(OutX_1+150+10,OutY_1+180)
		if(GetColor = ExpColor){
			NOWSTAT2.value := "color det"
			break
		} else {
			NOWSTAT2.value := "color not det"
		}
		Sleep(10)
	}
 	;;保存ボタンの検索
	SX := AWh * 0.5
	SY := OutY_1+184+100
	EX := AWw * 1.0
	EY := AWh * 1.0	
	det_cnt := 0
	loop {
		result := ImageSearchOR(&OutX_2,&OutY_2,SX,SY,EX,EY,VARI,WORKLOAD_KIND_SELECT_CATEGORY_IMG*) ;;;画像は違うが保存枠探索に流用
		if (result >= 1) {
			det_cnt += 1
		} else {
			det_cnt := 0
		}

		if(det_cnt > 2){
			; MouseMove(OutX_2, OutY_2)
			Click(,OutX_2, OutY_2)
			NOWSTAT2.value := OutX_2 " " OutY_2
			break
		} else if(A_index > 40) {
			NOWSTAT2.value := "img not Found"
			return 1
		}
	}
}

; mode : 1 = single, 2 = burst, any = debug
TMAtnd_dlysmry_workload_input(mode,know := "Z", tech := "Z",wkload := "00:00"){
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	;;;工数内訳セットの検索
	SX := 0
	SY := AWh * 0.1
	EX := AWw * 0.5
	EY := AWh * 1.0
	VARI := "*5"
	NOWSTAT1.value := "1:"
	Loop { ;;; date_search後に入る事を想定して数秒待機する
		ExitCodeChk
		; result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,WORKLOAD_SETTOP_IMG*)
		result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,WORKLOAD_JOB_DRAGICON_IMG*)
		if (result >= 1) {
			; MouseMove(OutX, OutY)
			set_topX := OutX
			set_topY := OutY
			NOWSTAT2.value := OutX " " OutY
			NOWSTAT1.value := "1:detected."
			break
		} else if(A_index > 20) {
			NOWSTAT2.value := "1:img not Found"
			return 1
		}
		Sleep(100)
	}
	;;;入力画面の左アイコン検索
	SX := AWw * 0.40
	SY := set_topY
	EX := AWw * 1.00
	EY := AWh * 1.0
	VARI := "*5"
	result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,WORKLOAD_KIND_LEFT_IMG*)
	if (result >= 1) {
		kind_leftX := OutX
		kind_leftY := OutY
		NOWSTAT2.value := OutX " " OutY
	} else {
		NOWSTAT2.value := "2:img not Found"
		return 1
	}
	;;; 入力画面の右アイコン検索
	SX := AWw * 0.40
	SY := set_topY
	EX := AWw * 1.00
	EY := AWh * 1.0
	VARI := "*5"
	result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,WORKLOAD_KIND_RIGHT_IMG*)
	if (result >= 1) {
		kind_rightX := OutX
		kind_rightY := OutY
		NOWSTAT2.value := OutX " " OutY
	} else {
		NOWSTAT2.value := "3:img not Found"
		return 1
	}
	;;; 入力枠検索
	SX := kind_leftX - 20  ;;;+マージン
	SY := set_topY - 20    ;;; 1行当たり56pixel … 行数×56で複数行対応可能？
	EX := kind_rightX + 20 ;;;+マージン
	EY := set_topY + 35	   ;;; 1行当たり56pixel
	VARI := "*5"
	pulldown_cnt := 0
	loop {
		ExitCodeChk
		;;;メイン枠処理
		result_m := ImageSearchOR(&OutX_m,&OutY_m,SX,SY,EX,EY,VARI,WORKLOAD_KIND_INPUT_IMG*)
		result_p := ImageSearchOR(&OutX_p,&OutY_p,SX,SY,EX,EY,VARI,WORKLOAD_KIND_PULLDOWN_IMG*)
		if (result_m >= 1) {
			; MouseMove(OutX_m+5, OutY_m+5)
			Click(,OutX_m+5, OutY_m+5)
			NOWSTAT2.value := OutX_m " " OutY_m
			NOWSTAT2.value := "detected_m."
			Sleep(10)
			TMAtnd_dlysmry_workload_select(AWx,AWy,AWw,AWh)
		} else if (result_p >= 1) { ;;プルダウン検出
			NOWSTAT2.value := "detected_p?"
			result_pf := ImageSearchOR(&OutX_pf,&OutY_pf,OutX_p-100,OutY_p-5,OutX_p+30,OutY_p+15,VARI,WORKLOAD_KIND_PULLDOWN_FIN_IMG*)
			if(result_pf >= 1){ ;;;検出したプルダウンが入力済みの時
				NOWSTAT2.value := "detected_pf."
			} else if((OutX_p - SX) < 120){ ;;; プルダウンの枠が一部隠れていた時
				NOWSTAT2.value := "detected_p but late."
			} else {
				; MouseMove(OutX_p+5, OutY_p+5)
				NOWSTAT2.value := OutX_P " " OutY_P
				NOWSTAT2.value := "detected_p."
				Sleep(10)
				if(pulldown_cnt = 0){
					TMAtnd_dlysmry_workload_pulldown(OutX_p+5, OutY_p+5,know)
					pulldown_cnt += 1
				} else {
					TMAtnd_dlysmry_workload_pulldown(OutX_p+5, OutY_p+5,tech)
				}
			}
		} else { ;;;入力済みかlast枠
			result_l := ImageSearchOR(&OutX_l,&OutY_l,SX,SY,EX,EY,VARI,WORKLOAD_KIND_LAST_IMG*)
			if (result_l >= 1){ ;;;last枠
				MouseMove(OutX_l+5, OutY_l+5)
				NOWSTAT2.value := OutX_l " " OutY_l
				NOWSTAT2.value := "detected_l."
				;;;工数実績入力
				Click(,kind_rightX+230,set_topY)
				Send wkload "{Enter}"
				Click(,kind_rightX+180,set_topY) ;;;次の枠の実績にフォーカスが移るので解除させる
				;;;保存位置探索
				;;保存位置のX軸探索範囲は工数の入力位置(230)+80まで
				result := ImageSearchOR(&OutX,&OutY,kind_rightX,kind_rightY,kind_rightX+230+80,AWh * 1.00,VARI,WORKLOAD_KIND_APPLY_IMG*)
				if (result >= 1) {
					switch mode
					{
						case 1 : Click(,OutX+100, OutY) ;;; 保存して閉じる
						case 2 : Click(,OutX, OutY) ;;; 保存
						default : MouseMove(OutX, OutY) ;;; 保存
					}
					; NOWSTAT2.value := OutX " " OutY
				} else {
					NOWSTAT2.value := "4:img not Found"
					return 1
				}
				return 0
			}
		}
		Click(,kind_rightX,kind_rightY) ;;;次の項目に移動(右カーソルのクリック)
		sleep(150) ;;;スクロール完了待ち（待機時間要調整）
	}
}

TMAtnd_dlysmry_workload_date_search(day_num := 1){
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	;;;スケーリング位置探索
	SX := AWw * 0.5
	SY := 0
	EX := AWw * 1.0
	EY := AWh * 0.5
	VARI := "*5"
	loop {
		ExitCodeChk
		resultS1 :=  ImageSearchOR2(&OutX_S1,&OutY_S1,SX,SY,EX,EY,VARI,WORKLOAD_KIND_SCALING_TRANS,WORKLOAD_KIND_SCALING_IMG[1])
		resultS2 :=  ImageSearchOR2(&OutX_S2,&OutY_S2,SX,SY,EX,EY,VARI,WORKLOAD_KIND_SCALING_TRANS,WORKLOAD_KIND_SCALING_IMG[2])
		if (resultS1 >= 1 && resultS2 >= 1) {
			if(OutX_S1 <= OutX_S2){
				OutX := OutX_S1
				OutY := OutY_S1
			} else {
				OutX := OutX_S2
				OutY := OutY_S2
			}
			; MouseMove(OutX, OutY)
			NOWSTAT2.value := OutX " " OutY
			GetTextFromClipboard(OutX-137,OutY,2)
			Send "{Esc}"
			NOWSTAT1.Value := A_Clipboard
			if(ChkDigit(A_Clipboard)){
				NOWSTAT2.value := "Digit OK"
				break
			} else {
				NOWSTAT2.value := "Digit NG"
				;continue
			}
		} else if (A_index > 30) {
			NOWSTAT2.value := "Date search failed."
			return 1
		}
	}

	;;;この時点でクリップボードの中身が確認できている事が前提
	ofset_date := 0
	ExitCodeChk
	if(A_Clipboard = day_num){
		NOWSTAT2.value := "detected."
		return 0
	} else {
		ofset_date := A_Clipboard - day_num
		if(ofset_date > 0){
			Click(,OutX-240,OutY,Abs(ofset_date))     ;;; prevdate
			NOWSTAT2.value := "-" Abs(ofset_date)
			Sleep(500) ;loading開始まで待ち
			return 0
		} else { ;;; (ofset_date < 0)
			Click(,OutX-39,OutY,Abs(ofset_date)) ;;; nextdate
			NOWSTAT2.value := "+" Abs(ofset_date)
			Sleep(500) ;loading開始まで待ち
			return 0
		}
	}
}

TMAtnd_top_kinmubasho_loc_num(loc_name){
	switch loc_name
	{
		case ""						: return 1
		case "出社"					: return 2
		case "在宅：客先業務"		 : return 3
		case "在宅：社内業務のみ"	 : return 4
		case "その他"				: return 5
		default: return 1  ;;;空白
	}
}
;１．一覧画面の処理の簡易処理
; [1]空白,[2]出社,[3]在宅：客先勤務,[4]在宅：社内業務のみ,[5]その他
; mode : 1 = normal, any = debug
TMAtnd_top_kinmubasho(mode,in_X,in_Y,loc := 1, content := "",remarks := ""){
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	table_reset(,0)
	; MouseGetPos(&MoutX,&MoutY)
	X_ofs := 630 ;;勤務場所入力位置は固定（日付からの相対位置）
	X := in_X + X_ofs
	Y := in_Y
	SX := X - 80
	SY := Y - 80
	EX := X + 80
	EY := Y + 230
	VARI := "*5"
	; MouseMove(SX,SY)
	; Sleep 300
	; MouseMove(EX,EY)
	; Sleep 300
	
	Click(,X,Y)
	while(1) {
		ExitCodeChk
		result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,KINMBASHO_PULDOWN_IMG*)
		if (result >= 1) {
			Click(,OutX, OutY + KINMBASHO_PULDOWN_REL_YPOS[5]) ;;幅変更対策
			; Sleep(500)
			Click(,X,Y)
			; Sleep(500)
			Click(,OutX, OutY + KINMBASHO_PULDOWN_REL_YPOS[loc])
			sleep(10)
			Click(,X-100,Y,1) ;;バグ1対応
			MouseMove(X,Y)
			;;; Click(,,,2) ;;;ダブルクリックでプルダウンメニューが消えない箇所あり(バグ1)
			Send "{Tab}" ;;バグ1対応
			Send "{Tab}"
			if (content = ""){
			 	Send "{Delete}"				
			} else {
				Send content
			}
			NOWSTAT1.value := content
			Send "{Tab}"
			if (remarks = ""){
				Send "{Delete}"				
		    } else {
			   Send remarks
		    }
			SX := 309
			SY := AWh * 0.6
			EX := 600
			EY := AWh * 0.9
			VARI := "*5"
			detcnt := 0
			loop { ;;;スクロールチェック
				ExitCodeChk
				table_reset(,0)
				result := ImageSearchOR(&OutX_S,&OutY_S,SX,SY,EX,EY,VARI,SAVE_BUTTON_IMG*)
				if(result >= 1){
					detcnt += 1
				} else {
					detcnt := 0
					table_reset(-1,0) ;;;スクロール抜け対策
				}
				if(detcnt > 3){
					switch mode {
						case 1 : Click(,OutX_S, Y) ;;;保存
						default : MouseMove(OutX_S, Y)
					}
					NOWSTAT2.value := "det save"
					Sleep(500) ;ブラウザの保存処理が行われるまで待ち
					return
				}
				sleep(10)
			}
		} else {
			;dmy
		}
	}
}

;３.勤務時間の入力
;mode : 1 = save, 2 = request, any = debug
TMAtnd_tmsheet_input(mode, clkin := "00:00",clkout := "00:00", restall_arr*){
	;;;休憩データの解析
	if(Mod(restall_arr.length,3) != 0){ ;;;休憩は3項目で1セット
		NOWSTAT2.value := "invalid rest count"
		return 1
	}
	rest_cnt := Floor(restall_arr.length/3) ;;;休憩の枠数
	rest_start := []
	rest_end := []
	rest_smry := [] ;;;現時点では未使用(休憩のみ)

	loop rest_cnt {
		rest_start.Push(restall_arr[1+(A_index-1)*3])
		rest_end.Push(restall_arr[2+(A_index-1)*3])
		rest_smry.Push(restall_arr[3+(A_index-1)*3])
		; msgbox rest_start[A_index] " " rest_end[A_index] " " rest_smry[A_index] " "
	}
	
	;;;main
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	SX := AWw * 0.5
	SY := 0
	EX := AWw * 1.0
	EY := AWh * 0.7
	VARI := "*5"

	EY2 := AWh * 1.0
	;;;ダイアログが開いているかチェック
	NOWSTAT1.value := "wait tmsheet disp..."
	while(1){
		ExitCodeChk
		res0 := ImageSearchOR2(&OutX,&OutY,SX,SY,EX,EY2,VARI,DIALOG_REST_ADD_TRANS,DIALOG_REST_ADD_IMG*)
		if (res0 >= 1) {
			NOWSTAT1.value := "det tmsheet disp."
			break
		}
		sleep(10)
	}
	;;;申請位置チェック
	loop {
		ExitCodeChk
		result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,DIALOG_ATTEND_APPLY_IMG*)
		if (result >= 1) {
			; MouseMove(OutX, OutY)
			NOWSTAT2.value := OutX " " OutY
			aplpos_X := OutX
			aplpos_Y := OutY
			break
		} else if(A_index > 300) {
			NOWSTAT2.value := "button not Found"
			return -1
		}
		sleep(10)
	}
	;;; 休憩調整の初期設定
	if(rest_cnt <= 1){ ;;;ターゲット数補正(1以下の時は0にする)
		rm_icon_tgt := 0
	} else {
		rm_icon_tgt := rest_cnt
	}
	;;; 休憩数の調整
	while (1){
		SX := aplpos_X-220
		SY := aplpos_Y
		EX := aplpos_X
		EY := AWh * 1.0
		;;rmアイコンの探索
		rm_icon_cnt := 0
		loop {
			ExitCodeChk
			result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,DIALOG_REST_REMOVE_IMG*)
			if (result >= 1) {
				; MouseMove(OutX, OutY)
				NOWSTAT2.value := SY " " OutY
				rm_icon_cnt += 1
				SY := OutY+10
				continue
			} else {
				NOWSTAT2.value := "rm_cnt " rm_icon_cnt
				break
			}
		}
		;;addアイコンを探索して追加
		SY := aplpos_Y
		rmneed := rm_icon_tgt - rm_icon_cnt
		if (rmneed < 0) { ;;rmアイコン削除
			if (rm_icon_tgt = 0) {
				rmneed += 1 ;;;tgtが0の時は最後の減算で-2される
			}
			loop Abs(rmneed) {
				ExitCodeChk
				result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,DIALOG_REST_REMOVE_IMG*)
				if (result >= 1) {
					Click(OutX, OutY)
					MouseMove(OutX, SY)
				} else {
					NOWSTAT2.value := "nd:" rmneed " tgt:" rm_icon_tgt " rm button not Found"
					return -1
				}
			}
			sleep(50)
		}
		else if (rmneed > 0) { ;;rmアイコン追加
			if (rm_icon_cnt = 0) {
				rmneed -= 1 ;;;1つもアイコンが無い時は最初の加算で+2される
			}
			err_cnt := 0
			loop rmneed {
				ExitCodeChk
				result := ImageSearchOR2(&OutX,&OutY,SX,SY,EX,EY,VARI,DIALOG_REST_ADD_TRANS,DIALOG_REST_ADD_IMG*)
				if (result >= 1) {
					Click(OutX, OutY)
					MouseMove(OutX, SY)
				} else {
					if (err_cnt > 5){
						NOWSTAT2.value := "add button not Found"
						return -1
					}
					NOWSTAT2.value := "retry search"
					err_cnt += 1
					A_index -= 1
				}
				sleep(50)
			}
		}
		else { ;;(rmneed = 0)
			NOWSTAT1.Value := "rm count OK."
			break
		}
	}
	;;; 勤務時間の入力
	SX := AWw * 0.1
	SY := 0
	EX := AWw * 1.0
	EY := AWh * 0.7
	VARI := "*5"
	result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,DIALOG_ATTEND_APPLY_IMG*)
	if (result >= 1) {
		NOWSTAT2.value := OutX " " OutY
		aplpos_X := OutX
		aplpos_Y := OutY
	} else {
		NOWSTAT2.value := "d2 button not Found"
		return
	}
	result := ImageSearchOR(&OutX2,&OutY2,SX,OutY+70,EX,EY,VARI,DIALOG_ATTEND_LINE_IMG*)
	if (result >= 1) {
		NOWSTAT2.value := OutX2 " " OutY2
	} else {
		NOWSTAT2.value := "d3 button not Found"
		return
	}
	Click(aplpos_X-566, OutY2-24,3) ;;;トリプルクリックで入力枠の全選択
	; SendText "{Ctrl Down}a{Ctrl Up}" 
	SendText clkin 
	Send "{TAB}"
	SendText clkout 
	Send "{TAB}"
	loop rest_cnt {
		SendText rest_start[A_index]
		Send "{TAB}"
		SendText rest_end[A_index]
		Send "{TAB}{TAB}{TAB}"
	}
	Send "{TAB}{TAB}{TAB}" ;;;フォーカスを「保存」の位置に合わせる
	switch mode {
		case 1 : ;;;保存処理
			;;; 休憩の個数で必要なTAB数は変動するため保存の位置は探索した方が確実
			result := ImageSearchOR(&OutX_S,&OutY_S,aplpos_X,aplpos_Y+30,aplpos_X+80,AWh*0.9,VARI,DIALOG_ATTEND_APPLY_IMG*)
			Click(,OutX_S,OutY_S) ;;;保存処理
		case 2 : ;;;申請処理
			Click(,aplpos_X,aplpos_Y)
		default :
			MouseMove(aplpos_X,aplpos_Y)
	}
}

;;３．出勤、退勤を自動入力の事前処理
; 保存枠の場所から日付が記載されている位置を特定し、日付の取得と出勤、退勤の入力状況をチェックする
TMAtnd_top_tmsheet_chk(Y := unset){
	d_ptX := 110
	d_ptY := 340
	VARI := "*5"

	d_curPosX := d_ptX
	d_curPosY := Y + 10
	; GetTextFromClipboard(,,2)
	; NOWSTAT1.Value := A_Clipboard
	;;; 勤務時間に値が入力されているか確認する
	ofsin_SX  := 50
	ofsin_EX  := 127
	ofsin_SY  := -28
	ofsin_EY  := 14
	; ofsout_SX := 122
	; ofsout_EX := 201
	; ofsout_SY := -28
	; ofsout_EY := 14
	SX_i := d_curPosX + ofsin_SX
	SY_i := d_curPosY + ofsin_SY
	EX_i := d_curPosX + ofsin_EX
	EY_i := d_curPosY + ofsin_EY
	; SX_o := d_curPosX + ofsout_SX
	; SY_o := d_curPosY + ofsout_SY
	; EX_o := d_curPosX + ofsout_EX
	; EY_o := d_curPosY + ofsout_EY
	result_i := ImageSearchOR(&OutX_i,&OutY_i,SX_i,SY_i,EX_i,EY_i,VARI,ATTEND_IMG*)
	; result_o := ImageSearchOR(&OutX_o,&OutY_o,SX_o,SY_o,EX_o,EY_o,VARI,ATTEND_IMG*)
	if (result_i >= 1) {
		NOWSTAT2.value := "Blank det:" result_i
	} else {
		NOWSTAT2.value := "Entered"
		return 1
	}
	; MouseMove(SX_o,SY_o)
	; Sleep(300)
	; MouseMove(EX_o,EY_o)
	; Sleep(300)
	; MouseMove(OutX_o+15,OutY_o+5)
	Click(,OutX_i+15,OutY_i+5)
	return 0
}

;;
; 保存枠の場所から日付が記載されている位置を特定し、日付の取得と工数の入力状況をチェックする
TMAtnd_top_dlysmrystat_chk(Y := unset){
	d_ptX := 110
	d_ptY := 340
	VARI := "*5"

	d_curPosX := d_ptX
	d_curPosY := Y + 10
	; GetTextFromClipboard(,,2)
	; NOWSTAT1.Value := A_Clipboard
	;;; 工数に値が入力されているか確認する
	ofs_SX  := 285
	ofs_EX  := 335
	ofs_SY  := -14
	ofs_EY  := 24
	SX := d_curPosX + ofs_SX
	SY := d_curPosY + ofs_SY
	EX := d_curPosX + ofs_EX
	EY := d_curPosY + ofs_EY
	result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,TABLE_ADD_IMG*)
	if (result >= 1) {
		NOWSTAT2.value := "Blank det:" result
		; MouseMove(OutX,OutY)
		Click(,OutX,OutY)
		return 0
	} else {
		NOWSTAT2.value := "Entered"
		return 1
	}
	; MouseMove(EX,EY)
}

;;４．申請自動入力の事前処理
; 保存枠の場所から日付が記載されている位置を特定し、日付の取得と申請の有無（勤務時間変更）をチェックする
TMAtnd_top_request(Y := unset){
	d_ptX := 110
	d_ptY := 340
	VARI := "*5"

	d_curPosX := d_ptX
	d_curPosY := Y + 10
	; GetTextFromClipboard(d_curPosX, d_curPosY,2)
	;;; 勤務時間に値が入力されているか確認する
	ofsreq_SX  := -70
	ofsreq_EX  := -10
	ofsreq_SY  := -14
	ofsreq_EY  := 26
	SX := d_curPosX + ofsreq_SX
	SY := d_curPosY + ofsreq_SY
	EX := d_curPosX + ofsreq_EX
	EY := d_curPosY + ofsreq_EY
	result := ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,TABLE_REQUEST_ADD_IMG*)
	if (result >= 1) {
		NOWSTAT2.value := "det:" result
		; MouseMove(OutX, OutY)
		Click(,OutX, OutY)
		; TMAtnd_request_flex ;;;wrap側から入る
		return 0
	} else {
		NOWSTAT2.value := "Applied"
		return 1
	}
	; MouseMove(SX,SY)
	; Sleep(300)
	; MouseMove(EX,EY)
}
;;; フレックス以外の処理にも対応させる
;mode : 1 = normal, 2 = Pseudo, any = debug
TMAtnd_request_flex(mode){
	NOWSTAT2.value := "wait disp dialog"
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	;;;申請ダイアログの検索
	SX := 0
	SY := AWh * 0.0
	EX := AWw * 1.0
	EY := AWh * 1.0
	VARI := "*5"
	loop {
		ExitCodeChk
		result := ImageSearchOR(&OutX_1,&OutY_1,SX,SY,EX,EY,VARI,DIALOG_REQUEST_TOP_IMG*)
		if (result >= 1) {
			MouseMove(OutX_1, OutY_1)
			NOWSTAT2.value := OutX_1 " " OutY_1
			break
		} else if(A_index > 100) {
			NOWSTAT2.value := "img not Found"
			return 1
		}
		sleep(50)
	}
	;;;勤務時間変更の選択
	Click(,OutX_1-100,OutY_1+83)
	;;;申請枠を探索する（ローディングに時間がかかるので数秒ポーリングする）
	loop {
		ExitCodeChk
		Click("WU",OutX_1+10,OutY_1+83,1) ;;;ローディング中にWDし続けると応答を受け付けないので一瞬WUを行う
		Sleep(10)
		Click("WD",OutX_1+10,OutY_1+83,50)
		Sleep(100) ;;;スクロールは処理が低速なので待ち時間を設ける
		result := ImageSearchOR(&OutX_2,&OutY_2,SX,SY,EX,EY,VARI,DIALOG_REQUEST_APPLY_IMG*)
		if (result >= 1) {
			Click("WD",OutX_2,OutY_2,50) ;;稀に見つかった後に上に戻る時がある

			switch mode {
				case 1 :  Click(,OutX_2, OutY_2)
				case 2 :  Click(,OutX_2, OutY_2+80) ;;;キャンセル
				default : MouseMove(OutX_2, OutY_2)
			}
			NOWSTAT2.value := "det:" OutX_2 " " OutY_2
			return 0
		} else if(A_Index > 20) {
			NOWSTAT2.value := "req img not Found"
			return 1
		}
	}
}

; mcnt : loop回数。PCの処理能力によるが、1カウントで最小10ms
TMAtnd_top_wait_loading(maxcnt := 500){
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	MouseMove(AWw*0.8,AWh*0.8) ;;table_resetの有効位置まで移動
	table_reset(,0)

	VARI := "*0"
	det_cnt := 0
	NOWSTAT1.value := "wait return top..."
	loop {
		ExitCodeChk
		result_f := ImageSearchOR(&OutX_f,&OutY_f,AWw*0.1,AWh*0.0,AWw*0.9,AWh*0.9,VARI,SAVE_BUTTON_IMG*)
		if (result_f >= 1) {
			det_cnt += 1
			if (det_cnt > 9){ ;;;top画面を検出してから最低100ms以上待つ
				NOWSTAT1.value := "det return top."
				return 0 ;; det save
			}
		} else if (A_index > maxcnt) {
			NOWSTAT2.value := "SAVE is not Found"
		} else {
			det_cnt := 0
			table_reset(,0)
		}
		Sleep(10)
	}
}

;[勤務表モード]指定した日付の位置を探索する。
;戻り値
;0 : 検出、-1 : 検出失敗
TMAtnd_top_search_day(OutX_day,OutY_day,day_num := 1,preY_day := unset){
	WinGetClientPos(&AWx,&AWy,&AWw,&AWh,"A")
	d_ptX		:= 110
	d_ptY		:= 0  ;;; Yの位置は変動するので最初に走査する
	table_ofs	:= 35 ;;;1行当たりの幅(特定の条件で幅が変動するので注意)
	savebtn_ofs	:= 32 ;;; save枠の大きさ
	;;;スクロール下限検出用
	scr_flg		:= false
	prev_date	:= 0 ;;;スクロール直後に読んだ値
	missing_scr := 0 ;;;スクロールされなかった回数
	VARI := "*0"

	;;; 現在位置の日付がpreY_dayと一致するかチェック。真なら処理をスキップ
	if(IsSet(preY_day)){
		NOWSTAT2.value := "preY chk"
		Sleep(500)
		A_Clipboard := ""
		GetTextFromClipboard(d_ptX,preY_day,2)
		if(day_num = A_Clipboard){
			%OutX_day% := d_ptX
			%OutY_day% := preY_day
			NOWSTAT2.value := "preY chk true"
			return 0
		}
		NOWSTAT2.value := "preY chk false"
	}
	;テーブル位置のリセット
	MouseMove(AWw*0.8,AWh*0.8) ;;table_resetの有効位置まで移動
	table_reset

	;;SAVE探索
	loop {
		ExitCodeChk
		result_s := ImageSearch_if(&OutX_s,&OutY_s,AWw*0.1,AWh*0.0,AWw*0.9,AWh*0.9,VARI,2,SAVE_BUTTON_IMG*)
		if (result_s >= 1){
			d_ptY := OutY_s - 5
			break
		} else if(A_index > 30) {
			NOWSTAT2.value := "SAVE is not Found"
			return -1
		}
		Sleep(10)
	}
	;;;日付列探索
	while(1){
		ExitCodeChk
		SX := 309
		SY := d_ptY
		EX := 600
		EY := d_ptY+(savebtn_ofs*2)
		VARI := "*5"
		; MouseMove(SX,SY)
		; Sleep(100)
		; MouseMove(EX,EY)
		; Sleep(100)

		;;;該当行のSAVE_BUTTON探索
		det_save_button := 0
		loop {
			ExitCodeChk
			result := ImageSearch_if(&OutX,&OutY,SX,SY,EX,EY,VARI,2,SAVE_BUTTON_IMG*)
			if (result >= 1) {
				MouseMove(d_ptX, OutY + 10)
				; dbg1 := (OutY - SY)
				; NOWSTAT1.value := "SY:" SY " OutY:" OutY " diff" dbg1
				; Sleep(500)
				d_curPosX := d_ptX
				d_curPosY := OutY + 10
				det_save_button := 1
				break
			} else if(A_index > 3) {
				det_save_button := 0
				break
			}
		}
		;;;save_button探索失敗時に下限位置を探索
		if (!det_save_button){
			result_u := ImageSearchOR(&OutX_bar,&OutY_bar,0,AWh*0.8,AWw*0.2,AWh*1.0,VARI,TABLE_LEFT_IMG*)
			if(result_u >= 1){
				under_ofs := (AWh - OutY_bar)
			}else{
				under_ofs := 0
			}
			if((SY + savebtn_ofs) >= (AWh - under_ofs)){ ;;下限に到達した時
				MouseClick("WD",SX,SY,1) ;;;有効範囲に移動してスクロール
				Sleep(100) ;スクロール待ち
				d_ptY -= table_ofs * 6
				scr_flg := true
				A_index := 0
				continue
			} else { ;;全て見える状態で検出できないとき
				NOWSTAT2.value := "SAVE is not Found"
				return -1
			}
		}

		A_Clipboard := ""
		; NOWSTAT2.value := lpcnt
		GetTextFromClipboard(,,2)
		; NOWSTAT1.Value := A_Clipboard
		if (scr_flg = true){
			if (prev_date = A_Clipboard){ ;;scroll直後にprev_dateとコピー値が同じであればscroll失敗
				missing_scr += 1
			}
			prev_date := A_Clipboard
			scr_flg := false
		}

		if (A_Clipboard = day_num){
			NOWSTAT2.Value := "detected."
			%OutX_day% := d_ptX
			%OutY_day% := OutY + 10
			return 0
		}
		else if (missing_scr >= 3){
			NOWSTAT2.Value := "scroll failed."
			return -1
		}
		else {
			if (A_Clipboard < (day_num-5) && EY + (5 * table_ofs) <= AWh){
				d_ptY += 3 * table_ofs
			} else {
				d_ptY := OutY + savebtn_ofs
			}
		}
	}
}
;;;;; common2(このスクリプト内での共通)

;該当行の保存枠が有効であるかチェック
;戻り値 bool
TMAtnd_top_save_available_chk(in_X,in_Y){
	table_reset(,0)
	; MouseGetPos(&MoutX,&MoutY)
	X_ofs := 420 ;;勤務場所入力位置は固定（日付からの相対位置）
	X := in_X + X_ofs
	Y := in_Y
	GetColor := PixelGetColor(X,Y)
	LOOP SAVE_BUTTON_COLOR_EN.Length {
		if (GetColor = SAVE_BUTTON_COLOR_EN[A_index]) {
			return true
		}
	}
	LOOP SAVE_BUTTON_COLOR_DIS.Length {
		if (GetColor = SAVE_BUTTON_COLOR_DIS[A_index]) {
			return false
		}
	}
	;;;未検出
	NOWSTAT2.value := "[ERROR]SAVE button det error! 2"
	Exit
}

;申請枠が空欄であるかをチェック
;戻り値 trueで有効データ、falseで無効データ
DataValidityChk(date){
	global employ_arr
	if(employ_arr[date][2] = ""){
		return false
	}
	return true
}

;指定したwindowがアクティブになるまで待機する
wait_window_active_tgt(tgt := "勤務表 | Salesforce"){
	while(1) {
		try {
			ExitCodeChk
			ActiveWinTitle := WinGetTitle("A")
			if(InStr(ActiveWinTitle,tgt)){
				SB.SetText("detected")
				break
			} else {
				SB.SetText("waiting select " tgt " window...")
			}
			Sleep(50)
		}
		catch {
			;; dmy
		}
	}
}

employ_load_chk(*){
	global employ_loaded
	if(employ_loaded = 0){
		SB.SetText("")
		Sleep(40)
		SB.SetText("Please D&D your employment information.")
		Sleep(10)
		return 1
	}
	return 0
}

;;;
employment_data_load(fpass := ""){
; FileEncoding "UTF-8"
	fl := FileOpen(fpass,"r")
	; main_arr := []
	global employ_arr
	lpcnt := 0
	while(1) {
		lpcnt += 1
		inner_pre_arr := []
		tmp := fl.ReadLine()
		if(lpcnt = 1){
			if(SubStr(tmp,1,3) != "###"){ ;;;意図しないテキストの読み込み防止
				msgbox "[Error] invalid text"
				return 1
			} else{
				employ_arr := []  ;;;読み込み直しのため空にする
			}
		}
		if(SubStr(tmp,1,1) = "#"){
			continue ;;; コメント
		}
		if(tmp = ""){
			break
		}
		tmp_arr := StrSplit(tmp,A_Tab)
		loop tmp_arr.Length {
			inner_pre_arr.Push(tmp_arr[A_index])
		}
		; main_arr.Push(inner_pre_arr)
		employ_arr.Push(inner_pre_arr)
	}
	; msgbox main_arr[1][1] " " main_arr[1][2] " " main_arr[1][4] ;;;[日付(ID)][項目]
	global employ_loaded := 1
	SB.SetText("Employment info has been loaded.")
}

;テーブルの位置をリセットする。X,Yのいずれかを0にするとその方向のリセットは行わない
table_reset(X := 1,Y := 1){
	if(Y > 0){
		MouseClick("WU",,,100)
	} else if (Y < 0) {
		MouseClick("WD",,,1)
	}

	if(X > 0){
		Send("{SHIFT Down}")
		MouseClick("WU",,,100)
		Send("{SHIFT Up}")
	}
	else if (X < 0) {
		Send("{SHIFT Down}")
		MouseClick("WD",,,1)
		Send("{SHIFT Up}")
	}
	Sleep(200)
	;;スクロールが完了するまで待機する仕組みが必要かも
}

Gui_DropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y){
	;;FileArray[1](最初のファイルのみ取得)
	fl_path := FileArray[1]
	SplitPath(fl_path,,,&fl_ext)
	if(fl_ext = "txt" || fl_ext = "tsv"){
		employment_data_load(fl_path)
	} else {
		; msgbox fl_ext
		SB.SetText("Please load a `"txt`" or `"tsv`" file.")
	}
}

GetTextFromClipboard(X := unset,Y := unset,CNT := 1){
	A_Clipboard := ""
	; NOWSTAT2.value := lpcnt
	Click(,X?,Y?,CNT)
	Send "{Ctrl Down}c"
	sleep(10)
	Send "{Ctrl Up}"
	loop {
		; NOWSTAT1.value := A_index
		if (A_Clipboard != ""){
			NOWSTAT2.Value := A_Clipboard
			break
		} if(A_index > 20){
			SB.SetText("Failed to retrieve from the clipboard.")
			return 1
		}
		sleep(10)
	}
}

; 00～99 のみであるかチェック
;戻り値 bool
ChkDigit(text){
	; text := Trim(text) ;;これはChkDigitへの受け渡し前に行った方が良い
	return RegExMatch(text, "^\d{2}$") ? true : false
}
;;;;; common(他のスクリプトでも共通)

CloseApp(*){
	ExitApp
}

; 複数の画像を検索し、最初に検出された配列番号を返す
; 戻り値
; img detect = more than 1, img not detect = 0
ImageSearchOR(&OutX,&OutY,SX,SY,EX,EY,VARI,IMGSET*){
	result := 0
	LOOP IMGSET.Length {
		result := ImageSearch(&OutX,&OutY,SX,SY,EX,EY,VARI " " IMGSET[A_Index])
		if (result = 1) {
			return A_Index
		}
	}
	return 0
}

; 指定した画像を全て検索し、その中から指定条件に当てはまる画像情報を返却する
;
; 引数
; <mode> 1:less then X, 2:less than Y, 3:more than X, 4: more than Y
; 戻り値
; img detect = more than 1, img not detect = 0
ImageSearch_if(&OutX,&OutY,SX,SY,EX,EY,VARI,mode,IMGSET*){
	result_arr := []
	res_X_arr := []
	res_Y_arr := []
	NOWSTAT2.Value := ""
	LOOP IMGSET.Length {
		result := ImageSearch(&p_OutX,&p_OutY,SX,SY,EX,EY,VARI " " IMGSET[A_Index])
		result_arr.Push(result)
		res_X_arr.Push(p_OutX)
		res_Y_arr.Push(p_OutY)
	}
	switch mode {
		case 1 : res := GetMinValueAndIndex(res_X_arr)
		case 2 : res := GetMinValueAndIndex(res_Y_arr)
		case 3 : res := GetMaxValueAndIndex(res_X_arr)
		case 4 : res := GetMaxValueAndIndex(res_Y_arr)
		default : return 0
	}
	; NOWSTAT2.Value := "dbg1:" res.index
	if ( res.index = 0 ) {
		return 0
	}
	OutX := res_X_arr[res.index]
	OutY := res_Y_arr[res.index]
	; Msgbox "i:" res.index " X:" OutX " Y:" OutY
	return res.index
}

; TRANS設定有効版
; 戻り値
; img detect = more than 1, img not detect = 0
ImageSearchOR2(&OutX,&OutY,SX,SY,EX,EY,VARI,TRANS,IMGSET*){
	result := 0
	LOOP IMGSET.Length {
		result := ImageSearch(&OutX,&OutY,SX,SY,EX,EY,VARI " " TRANS " " IMGSET[A_Index])
		if (result = 1) {
			return A_Index
		}
	}
	return 0
}

GetMaxValueAndIndex(arr) {
    maxValue := ""
    maxIndex := 0
    for index, value in arr {
        if (value = "")
            continue
        value := value + 0  ; 数値として扱う
        if (maxIndex = 0 || value > maxValue) {
            maxValue := value
            maxIndex := index
        }
    }
    return {value: maxValue, index: maxIndex}
}
GetMinValueAndIndex(arr) {
    minValue := ""
    minIndex := 0
    for index, value in arr {
        if (value = "")
            continue
        value := value + 0  ; 数値として扱う
        if (minIndex = 0 || value < minValue) {
            minValue := value
            minIndex := index
        }
    }
    return {value: minValue, index: minIndex}
}

ExitCodeChk(key := "Pause")
{
	if (GetKeyState(key, "P")) {
		TraySetIcon("*")
		SB.SetText("About.")
		; NOWSTAT2.Value := "About."
		Exit
	}
}

