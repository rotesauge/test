
&НаКлиенте
&Вместо("ОткрытиеВВебКлиенте")
Процедура Pcru_ОткрытиеВВебКлиенте()
	#Если ВебКлиент Тогда
		Элементы.ДеревоПапок.Доступность=Истина;
		ВариантПапокПриИзменении(Неопределено);
		
		НеАктивизироватьСтроку=Ложь;
		
		Если ПапкиОтключены=Неопределено Тогда
			ПапкиОтключены=Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяВариантаГруппировки) Тогда
			СгруппироватьСписокНавигатораСервером(ИмяВариантаГруппировки);
		КонецЕсли;
		
		УстановитьПериодЖурнала();
		
		УстановитьВидимостьПапок();
		
		УстановитьЭлементыПредпросмотра();
	#КонецЕсли
КонецПроцедуры
