
&Вместо("ВопросПользователюПередЗавершениемРаботыСистемы")
Процедура Pcru_ВопросПользователюПередЗавершениемРаботыСистемы(Параметры, ОбработкаОтвета)
	//ПродолжитьВызов(Параметры, ОбработкаОтвета);
КонецПроцедуры

&Вместо("ПараметрыРаботыКлиентаПриЗавершении")
Функция Pcru_ПараметрыРаботыКлиентаПриЗавершении()
	Возврат ПараметрыПриЗапускеИЗавершенииПрограммы.ПараметрыРаботыКлиентаПриЗавершении;
КонецФункции

&Вместо("ПроверитьВерсиюПлатформыПриЗапуске")
Процедура Pcru_ПроверитьВерсиюПлатформыПриЗапуске(Параметры)
	//ПродолжитьВызов(Параметры);
КонецПроцедуры
