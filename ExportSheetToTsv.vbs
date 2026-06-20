Option Explicit

'==============================
' 設定
'==============================
Const TARGET_SHEET_MODE  = "LEFTMOST"   ' LEFTMOST / NAME / INDEX
Const TARGET_SHEET_NAME  = "Sheet1"     ' TARGET_SHEET_MODE = "NAME" のとき使用
Const TARGET_SHEET_INDEX  = 1           ' TARGET_SHEET_MODE = "INDEX" のとき使用

' 出力文字コード
' "utf-8"  : 日本語を扱いやすい
' "shift_jis" : 旧環境向け
Const OUTPUT_CHARSET = "shift_jis"

'==============================
' メイン
'==============================
Dim fso, xl, wb, ws
Dim xlsxPath, outPath, baseName, sheetName, folderPath

If WScript.Arguments.Count < 1 Then
    WScript.Echo "Usage: cscript //nologo ExportSheetToTsv.vbs <xlsx file path>"
    WScript.Quit 1
End If

xlsxPath = WScript.Arguments(0)

Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FileExists(xlsxPath) Then
    WScript.Echo "File not found: " & xlsxPath
    WScript.Quit 1
End If

Set xl = CreateObject("Excel.Application")
xl.Visible = False
xl.DisplayAlerts = False
xl.AskToUpdateLinks = False

On Error Resume Next
Set wb = xl.Workbooks.Open(xlsxPath, False, True) ' ReadOnly
If Err.Number <> 0 Then
    WScript.Echo "Failed to open workbook: " & Err.Description
    xl.Quit
    WScript.Quit 1
End If
On Error GoTo 0

Set ws = GetTargetWorksheet(wb)
If ws Is Nothing Then
    WScript.Echo "Target sheet not found."
    wb.Close False
    xl.Quit
    WScript.Quit 1
End If

baseName = fso.GetBaseName(xlsxPath)
folderPath = fso.GetParentFolderName(xlsxPath)
sheetName = ws.Name

outPath = fso.BuildPath(folderPath, baseName & "_" & SanitizeFileName(sheetName) & ".tsv")

WriteWorksheetAsTsv ws, outPath

wb.Close False
xl.Quit

WScript.Echo "Saved: " & outPath

'==============================
' 対象シート取得
'==============================
Function GetTargetWorksheet(wb)
    Select Case UCase(TARGET_SHEET_MODE)
        Case "LEFTMOST"
            Set GetTargetWorksheet = wb.Worksheets(1)
        Case "NAME"
            On Error Resume Next
            Set GetTargetWorksheet = wb.Worksheets(TARGET_SHEET_NAME)
            On Error GoTo 0
        Case "INDEX"
            On Error Resume Next
            Set GetTargetWorksheet = wb.Worksheets(TARGET_SHEET_INDEX)
            On Error GoTo 0
        Case Else
            Set GetTargetWorksheet = wb.Worksheets(1)
    End Select
End Function

'==============================
' TSV出力
'==============================
Sub WriteWorksheetAsTsv(ws, outPath)
    Dim rng, r, c, rowCount, colCount
    Dim stm, line, cellValue, v

    Set rng = ws.UsedRange
    If rng Is Nothing Then Exit Sub

    rowCount = rng.Rows.Count
    colCount = rng.Columns.Count

    Set stm = CreateObject("ADODB.Stream")
    stm.Type = 2 ' adTypeText
    stm.Charset = OUTPUT_CHARSET
    stm.Open

    For r = 1 To rowCount
        line = ""

        For c = 1 To colCount
            v = rng.Cells(r, c).Text

            If VarType(v) = 10 Or IsNull(v) Or IsEmpty(v) Then
                cellValue = ""
            Else
                cellValue = CStr(v)
            End If

            cellValue = Replace(cellValue, vbCrLf, " ")
            cellValue = Replace(cellValue, vbCr, " ")
            cellValue = Replace(cellValue, vbLf, " ")
            cellValue = Replace(cellValue, vbTab, " ")

            If c > 1 Then line = line & vbTab
            line = line & cellValue
        Next

        stm.WriteText line, 1 ' adWriteLine
    Next

    stm.SaveToFile outPath, 2 ' adSaveCreateOverWrite
    stm.Close
End Sub

'==============================
' ファイル名に使えない文字を置換
'==============================
Function SanitizeFileName(s)
    Dim badChars, i
    badChars = Array("\", "/", ":", "*", "?", """", "<", ">", "|", "[", "]")
    For i = 0 To UBound(badChars)
        s = Replace(s, badChars(i), "_")
    Next
    SanitizeFileName = s
End Function
