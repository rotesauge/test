
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Состояние(НСтр("en='Creating new document ...';ru='Создание нового документа...'"));

    ДанныеЗаполнения=Новый Структура("ВидДокумента",СоздатьНовыйЗНО() );
	ДанныеЗаполнения=Новый Структура("НаименованиеДокумента", "Новый Приказ");
	ПараметрыФормы=Новый Структура("Основание,ВидДокумента", ДанныеЗаполнения);
    ПараметрыФормы.Вставить("ВидДокумента",СоздатьНовыйЗНО());
	
	Попытка
		ОткрытьФорму("Документ.аДокументооборотКорпоративныйДокумент.Форма.ФормаДокумента",ПараметрыФормы); 
	Исключение
		аДООбщееКлиент.СообщитьОбОшибке(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция СоздатьНовыйЗНО()
	 	    Возврат Справочники.аДокументооборотВидыДокументов.НайтиПоНаименованию("Приказ");
КонецФункции // СоздатьНовыйЗНО()
 
