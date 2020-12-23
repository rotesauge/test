// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ЗаписатьКонтрагента(JsonStr) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON; 
	ЧтениеJSON.УстановитьСтроку(JsonStr); 
	СтруктураКонтрагента= ПрочитатьJSON(ЧтениеJSON); 
	ЧтениеJSON.Закрыть();
	
	Запрос1 = Новый Запрос;
	Запрос1.Текст = "ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН = &ИНН
	|	И Контрагенты.КПП = &КПП
	|	И Контрагенты.Наименование = &Наименование";
	Запрос1.УстановитьПараметр("ИНН", СтруктураКонтрагента.ИНН);
	Запрос1.УстановитьПараметр("КПП", СтруктураКонтрагента.КПП);
	Запрос1.УстановитьПараметр("Наименование", СтруктураКонтрагента.Наименование);
	Результат1 = Запрос1.Выполнить();
	Выборка1 = Результат1.Выбрать();
	
	Если Выборка1.Следующий() тогда
		СпрОб = Выборка1.Ссылка.ПолучитьОбъект();
	Иначе	
		СпрОб = Справочники.Контрагенты.СоздатьЭлемент();
	КонецЕсли;
	//	
	//	
	//	{
	//"Код": "00-015707",
	//"ИНН": "9717012581",
	//"КПП": "771701001",
	//"РодительКод": "         ",
	//"Наименование": "ОНЛАЙН РЕГИОНЫ ООО",
	//"НаименованиеПолное": "ООО \"ОНЛАЙН РЕГИОНЫ\" 1",
	//"Комментарий": " ",
	//"ЮридическоеФизическоеЛицо": "ЮридическоеЛицо",
	//"КИ": [
	//{
	//"Тип": "Адрес",
	//"Регион": "129164",
	//"Вид": "ЮрАдресКонтрагента",
	//"Представление": "129164, Москва г, Ракетный б-р, дом № 16, этаж 7, помещение Хххi, помещение 23"
	//},
	//{
	//"Тип": "Адрес",
	//"Регион": "129164",
	//"Вид": "ФактАдресКонтрагента",
	//"Представление": "129164, Москва г, Ракетный б-р, дом № 16, этаж 7, помещение Хххi, помещение 23"
	//},
	//{
	//"Тип": "Адрес",
	//"Регион": "129164",
	//"Вид": "ПочтовыйАдресКонтрагента",
	//"Представление": "129164, Москва г, Ракетный б-р, дом № 16, этаж 7, помещение Хххi, помещение 23"
	//}
	//],
	//"БанкКод": "044525593",
	//"БанкНаименование": "АО \"АЛЬФА-БАНК\"",
	//"БанкКоррСчет": "30101810200000000593",
	//"БанкГород": "г. Москва",
	//"БанкАдрес": "ул Каланчёвская, 27",
	//"БанкТелефоны": "(495) 620-91-91",
	//"СчетНаименование": "40702810301600004715, АО \"АЛЬФА-БАНК\"",
	//"НомерСчета": "40702810301600004715",
	//"ТекстКорреспондента": "",
	//"ДатаОткрытия": "0001-01-01T00:00:00",
	//"ДатаЗакрытия": "0001-01-01T00:00:00",
	//"ТекстНазначенияПлатежа": ""
	//}
	//}
	Если СтруктураКонтрагента.РодительКод <> "" тогда
		СпрОб.Родитель = Справочники.Контрагенты.НайтиПоКоду(СтруктураКонтрагента.РодительКод);
	КонецЕсли;
	СпрОб.Наименование = СтруктураКонтрагента.Наименование;  //СтруктураКонтрагента.Наименование = "КПД ООО"
	Если Не ЗначениеЗаполнено(Справочники.Контрагенты.НайтиПоКоду(СтруктураКонтрагента.Код)) Тогда 
		СпрОб.Код = СтруктураКонтрагента.Код;
	КонецЕсли;
	СпрОб.НаименованиеПолное = СтруктураКонтрагента.НаименованиеПолное;
	СпрОб.КПП = СтруктураКонтрагента.КПП;
	СпрОб.ИНН = СтруктураКонтрагента.ИНН;
	СпрОб.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо[СтруктураКонтрагента.ЮридическоеФизическоеЛицо]; 
	//?(СтруктураКонтрагента.ЮридическоеФизическоеЛицо="ЮридическоеЛицо",Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо,Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
	Если  СтрЧислоВхождений(СпрОб.Комментарий,СтруктураКонтрагента.Комментарий) = 0 тогда 
		СпрОб.Комментарий = СпрОб.Комментарий +" "+ СтруктураКонтрагента.Комментарий;
	КонецЕсли;
	//
	Для каждого СтрокаКИ Из СтруктураКонтрагента.КИ Цикл
		СтрокаКИНов = СпрОб.КонтактнаяИнформация.Добавить();
		Попытка
			СтрокаКИНов.Тип = Перечисления.ТипыКонтактнойИнформации[СтрокаКИ.Тип];
		Исключение
		КонецПопытки; 
		Попытка
			СтрокаКИНов.Вид = Справочники.ВидыКонтактнойИнформации[СтрокаКИ.Вид];
		Исключение
		КонецПопытки; 
		СтрокаКИНов.Представление = СтрокаКИ.Представление;
		//
		СтрокаКИ.Свойство("Регион",СтрокаКИНов.Регион);
		СтрокаКИ.Свойство("НомерТелефона",СтрокаКИНов.НомерТелефона);
	КонецЦикла; 
	СпрОб.Записать();
	//
	//Банк =  Справочники.КлассификаторБанковРФ.НайтиПоКоду(СтруктураКонтрагента.БанкКод);
	//Если не ЗначениеЗаполнено(Банк)  Тогда
	//	БанкОбъект = Справочники.КлассификаторБанковРФ.СоздатьЭлемент();
	//	БанкОбъект.КоррСчет = СтруктураКонтрагента.БанкКоррСчет;
	//	БанкОбъект.Город = СтруктураКонтрагента.БанкГород;
	//	БанкОбъект.Адрес = СтруктураКонтрагента.БанкАдрес
	//	БанкОбъект.Телефоны = СтруктураКонтрагента.БанкТелефоны;
	//	БанкОбъект.Код = СтруктураКонтрагента.БанкКод;
	//	БанкОбъект.Наименование = СтруктураКонтрагента.БанкНаименование;
	//	БанкОбъект.Записать();
	//	Банк =	БанкОбъект.Ссылка;
	//КонецЕсли; 
	////
	БанковскийСчет	=	Справочники.БанковскиеСчета.СоздатьЭлемент();
	//	БанковскийСчет.Банк = Банк;
	//	БанковскийСчет.БанкДляРасчетов = Банк;
	Попытка
   	БанковскийСчет.Наименование = СтруктураКонтрагента.БанкНаименование;
	БанковскийСчет.НаименованиеБанка = СтруктураКонтрагента.БанкНаименование;
	БанковскийСчет.КоррСчетБанка = СтруктураКонтрагента.БанкКоррСчет;
	БанковскийСчет.ГородБанка = СтруктураКонтрагента.БанкГород;
	БанковскийСчет.ТелефоныБанка = СтруктураКонтрагента.БанкТелефоны;
	БанковскийСчет.АдресБанка = СтруктураКонтрагента.БанкАдрес;
	БанковскийСчет.БИКБанкаДляРасчетов = СтруктураКонтрагента.БанкКод;
	БанковскийСчет.ТекстКорреспондента = СтруктураКонтрагента.ТекстКорреспондента;
	БанковскийСчет.КоррСчетБанкаДляРасчетов = СтруктураКонтрагента.БанкКоррСчет;
	БанковскийСчет.ГородБанкаДляРасчетов = СтруктураКонтрагента.БанкГород;
	БанковскийСчет.АдресБанкаДляРасчетов = СтруктураКонтрагента.БанкАдрес;
	БанковскийСчет.ТелефоныБанкаДляРасчетов = СтруктураКонтрагента.БанкТелефоны;
	БанковскийСчет.ТекстНазначенияПлатежа = СтруктураКонтрагента.ТекстНазначенияПлатежа;
	БанковскийСчет.ДатаОткрытия = СтруктураКонтрагента.ДатаОткрытия;
	БанковскийСчет.ДатаЗакрытия = СтруктураКонтрагента.ДатаЗакрытия;
	БанковскийСчет.НомерСчета = СтруктураКонтрагента.НомерСчета;
	Исключение
     	БанковскийСчет.Наименование = "";
    	БанковскийСчет.НаименованиеБанка = "";
	БанковскийСчет.КоррСчетБанка = "";
	БанковскийСчет.ГородБанка = "";
	БанковскийСчет.ТелефоныБанка = "";
	БанковскийСчет.АдресБанка = "";
	БанковскийСчет.БИКБанкаДляРасчетов = "";
	БанковскийСчет.ТекстКорреспондента = "";
	БанковскийСчет.КоррСчетБанкаДляРасчетов ="";
	БанковскийСчет.ГородБанкаДляРасчетов = "";
	БанковскийСчет.АдресБанкаДляРасчетов = "";
	БанковскийСчет.ТелефоныБанкаДляРасчетов = "";
	БанковскийСчет.ТекстНазначенияПлатежа = "";
	БанковскийСчет.ДатаОткрытия = "";
	БанковскийСчет.ДатаЗакрытия = "";
	БанковскийСчет.НомерСчета = "";
	КонецПопытки;
	БанковскийСчет.Владелец = СпрОб.Ссылка;
	БанковскийСчет.Записать();
	//
	//ОбъектКонтактныеЛицаКонтрагентов = Справочники.КонтактныеЛицаКонтрагентов.СоздатьЭлемент();
	//ОбъектКонтактныеЛицаКонтрагентов.Владелец = СпрОб.Ссылка;
	//ОбъектКонтактныеЛицаКонтрагентов.Наименование =  СтруктураКонтрагента.КонтактныеДанные;
	//ОбъектКонтактныеЛицаКонтрагентов.КонтактныеДанные =  СтруктураКонтрагента.КонтактныеДанные;
	//ОбъектКонтактныеЛицаКонтрагентов.Записать();
	
	СпрОб = Неопределено;
	
	
КонецПроцедуры // ЗаписатьКонтрагента()