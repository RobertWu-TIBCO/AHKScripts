g_SelectedFile =



Gui, Add, Button, x6 y20 w100 h30  	g���򿪡�, ���ļ�(&F)
Gui, Add, Edit, 	x146 y22 w410 h25  -Multi 	v_search g��������ʽ�����,
Gui, Add, Button, x556 y20 w80 h30 	g��ƥ�䡿, ƥ��
Gui, Add, Edit, 	x686 y22 w300 h25  -Multi 	v_replace g���滻�ַ������,
Gui, Add, Button, x986 y20 w80 h30 	g���滻��, �滻
Gui, Add, Edit, 	x6 y90 w580 h550 	HScroll v_FileContent,
Gui, Add, Edit, 	x596 y90 w510 h550  HScroll v_NewContent, ��ƥ������
Gui, Add, Text, 	x6 y70 w440 h20 , ԭʼ�ı�
Gui, Add, Text, 	x596 y70 w440 h20 , �滻���ı�

Gui, Add, Checkbox, x986 y65 w200 h20 v_OnlyRepalceMatch, ֻ�滻��ƥ�����
Gui, Add, Checkbox, x146 y65 w200 h20 v_MatchByLine, ����ƥ��

Gui, Add, Button, x486 y62 w70 h22 g�����¼��ء�, Reload(&R)
; Generated using SmartGUI Creator 4.0
Gui, Show, x161 y206 h650 w1114, ������ʽ����
Return

GuiClose:
ExitApp


���򿪡�:
	FileSelectFile, g_SelectedFile, 3, , ѡ����Ҫ��������־�ļ�,
	if g_SelectedFile <>
	{
		FileRead var_temp, %g_SelectedFile%
		GuiControl , , _FileContent, %var_temp%
	}

	Return

��������ʽ�����:
	Gosub ��ƥ�䡿
	Return

��ƥ�䡿:
	Gui, submit, NoHide
	if _search <>
	{
		MatchBuf =
		if _MatchByLine
		{
			Loop parse, _FileContent, `n
			{
				if ( RegExMatch( A_LoopField, _search, var_match ) > 0 )
				{
					MatchBuf = %MatchBuf%%var_match%`n

				}
			}
		}
		else
		{
			if ( RegExMatch( _FileContent, _search, var_match ) > 0 )
			{
				MatchBuf := var_match
			}
		}
		GuiControl , , _NewContent, %MatchBuf%
	}
	Else
		GuiControl , , _NewContent,
	Return

���滻�ַ������:
	Return

���滻��:
	Gui, submit, NoHide
	if _search <>
	{
		MatchBuf =
		if _MatchByLine
		{
			Loop parse, _FileContent, `n
			{
				if ( !_OnlyRepalceMatch || RegExMatch( A_LoopField, _search ) > 0 )
				{
					var_match := RegExReplace( A_LoopField, _search, _replace )
					{
						MatchBuf = %MatchBuf%%var_match%`n
					}
				}
			}
		}
		else
		{
			if ( !_OnlyRepalceMatch || RegExMatch( _FileContent, _search ) > 0 )
			{
				var_match := RegExReplace( _FileContent, _search, _replace )
				{
			;	msgbox  RegExReplace( _FileContent`, %_search%`, %_replace% )`n`n%var_match%
					MatchBuf := var_match
				}
			}
		}
		GuiControl , , _NewContent, %MatchBuf%
	}
	Else
		GuiControl , , _NewContent,
	Return

�����¼��ء�:
	Reload
	Return
