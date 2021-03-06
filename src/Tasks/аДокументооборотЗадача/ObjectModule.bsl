

&После("ПриЗаписи")
Процедура Pcru_ПриЗаписи(Отказ)
	#Область pcru_ПараметрыВыданныхЗадач
	Если не ЗначениеЗаполнено(ЭтотОбъект.Исполнитель)  Тогда
		Возврат;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	аДокументооборотСсылкиПроцессов.Объект
	|ИЗ
	|	РегистрСведений.аДокументооборотСсылкиПроцессов КАК аДокументооборотСсылкиПроцессов
	|ГДЕ
	|	аДокументооборотСсылкиПроцессов.БизнесПроцесс = &БизнесПроцесс";
	Запрос.УстановитьПараметр("БизнесПроцесс",ЭтотОбъект.БизнесПроцесс );
	Выборка = Запрос.Выполнить().Выбрать();
	СписокОбъектов = Новый  СписокЗначений;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Объект) Тогда
			СписокОбъектов.Добавить(Выборка.Объект);
		КонецЕсли;
	КонецЦикла;
	Если СписокОбъектов.Количество() =0 Тогда
		Возврат;
	КонецЕсли; 		
	СсылкаНаЗадачу = ЭтотОбъект.Ссылка;
	СсылкаНаПроцесс = ЭтотОбъект.БизнесПроцесс;	
	Попытка
		Запись =  РегистрыСведений.pcru_ПараметрыВыданныхЗадач.СоздатьМенеджерЗаписи();
		Запись.БизнесПроцесс =  СсылкаНаЗадачу.БизнесПроцесс;
		Запись.ВидБизнесПроцесса =  СсылкаНаЗадачу.БизнесПроцесс.ВидПроцесса;
		Запись.Документ = СписокОбъектов[0].Значение;
		Запись.Задача =  СсылкаНаЗадачу.Ссылка;
		Запись.Исполнитель = СсылкаНаЗадачу.Исполнитель;
		Если  СписокОбъектов[0].Значение.КонтрагентыДоговоры.Количество() > 0 Тогда
			Запись.ДоговорКонтрагента =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].ДоговорКонтрагента;
			Запись.Контрагент  =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].Контрагент;
		КонецЕсли; 
		Если  СписокОбъектов[0].Значение.ОрганизацииПодразделения.Количество() > 0 Тогда
			Запись.Подразделение  = СписокОбъектов[0].Значение.ОрганизацииПодразделения[0].Подразделение;
		КонецЕсли; 
		Запись.Сумма =  СписокОбъектов[0].Значение.СуммаДокумента;
		Запись.Инициатор   =  СсылкаНаЗадачу.Автор;
		Запись.Выполнена = СсылкаНаЗадачу.Выполнена;
		//
		Запрос1 = Новый Запрос;
		Запрос1.Текст = "ВЫБРАТЬ
		|	аДокументооборотСостояниеДокументов.СостояниеДокумента
		|ИЗ
		|	РегистрСведений.аДокументооборотСостояниеДокументов КАК аДокументооборотСостояниеДокументов
		|ГДЕ
		|	аДокументооборотСостояниеДокументов.КорпоративныйДокумент = &КорпоративныйДокумент";
		Запрос1.УстановитьПараметр("КорпоративныйДокумент",СписокОбъектов[0].Значение );
		Выборка1 = Запрос1.Выполнить().Выбрать();
		Пока Выборка1.Следующий() Цикл
			Запись.СостояниеДокумента  =  Выборка1.СостояниеДокумента;
		КонецЦикла;
		Запись.ДатаВыполненияПлан =    СсылкаНаЗадачу.ДатаВыполненияПлан;
		Если СсылкаНаЗадачу.Выполнена Тогда
			ЗапросРез = Новый Запрос;
			ЗапросРез.Текст = "ВЫБРАТЬ
			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.ПараметрРезультата.Наименование as Наименование,
			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.ЗначениеПараметра
			|ИЗ
			|	РегистрСведений.аДокументооборотРезультатыИсполнителейЗадач.СрезПоследних КАК аДокументооборотРезультатыИсполнителейЗадачСрезПоследних
			|ГДЕ
			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.Задача = &Задача";
			ЗапросРез.УстановитьПараметр("Задача",СсылкаНаЗадачу );
			ВыборкаРез = ЗапросРез.Выполнить().Выбрать();
			Пока ВыборкаРез.Следующий() Цикл
				Если ВыборкаРез.Наименование = "Выбор кнопками панели" Тогда
					Запись.Согласовано =   ВыборкаРез.ЗначениеПараметра;
				КонецЕсли;
				Если ВыборкаРез.Наименование = "Текстовое сообщение" Тогда
					Запись.ТекстовыйРезультат =   ВыборкаРез.ЗначениеПараметра;
				КонецЕсли;
			КонецЦикла;
			Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.ВыполненныеЗадачи;
			Запись.ДатаВыполненияФакт   =    СсылкаНаЗадачу.ДатаВыполненияФакт;
		Иначе
			Запись.Согласовано =   "Не выполнена";
			Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.НаходятсяВРаботе;
			Запись.ТекстовыйРезультат =   "Не выполнена";
		КонецЕсли; 
		Запись.Записать(Истина);
	Исключение
	КонецПопытки;
	#КонецОбласти
	
	Если не СсылкаНаЗадачу.Выполнена Тогда
		МЗТИ = РегистрыСведений.Pcru_ТекущийИсполнительПоДокументу.СоздатьМенеджерЗаписи();
		МЗТИ.КорпоративныйДокумент = СписокОбъектов[0].Значение;
		МЗТИ.ТекущийИсполнитель = СсылкаНаЗадачу.Исполнитель;
		МЗТИ.Записать(Истина);
	Иначе 
		НЗ = РегистрыСведений.Pcru_ТекущийИсполнительПоДокументу.СоздатьНаборЗаписей();
		НЗ.Отбор.КорпоративныйДокумент.Установить(СписокОбъектов[0].Значение, Истина);
		НЗ.Прочитать();
		НЗ.Очистить();
		НЗ.Записать(Истина);
	КонецЕсли; 
	
КонецПроцедуры

//		НЗ.Отбор.Документ.Установить(СписокОбъектов[0].Значение, Истина);
//		НЗ.Отбор.БизнесПроцесс.Установить(СсылкаНаПроцесс, Истина);
//Попытка
//	Блокировка = Новый БлокировкаДанных;
//	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.pcru_ПараметрыВыданныхЗадач");
//	ЭлементБлокировки.УстановитьЗначение("Задача", СсылкаНаЗадачу);
//	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
//	Блокировка.Заблокировать();
//Исключение
//КонецПопытки;
//


//НЗ = РегистрыСведений.pcru_ПараметрыВыданныхЗадач.СоздатьНаборЗаписей();
//НЗ.Отбор.Задача.Установить(СсылкаНаЗадачу, Истина);
//НЗ.Прочитать();
//
//Индекс = 0;
//НетЗаписей = Ложь;
//Если НЗ.Количество() = 0 Тогда
//	НетЗаписей = Истина;
//	    Запись = НЗ.Добавить();


//Иначе 
//	Для каждого Запись  Из НЗ Цикл
//		
//		Запись.БизнесПроцесс =  СсылкаНаЗадачу.БизнесПроцесс;
//		
//		Запись.ВидБизнесПроцесса =  СсылкаНаЗадачу.БизнесПроцесс.ВидПроцесса;
//		
//		Запись.Документ = СписокОбъектов[0].Значение;
//		
//		Запись.Задача =  СсылкаНаЗадачу.Ссылка;
//		
//		Запись.Исполнитель = СсылкаНаЗадачу.Исполнитель;
//		
//		Если  СписокОбъектов[0].Значение.КонтрагентыДоговоры.Количество() > 0 Тогда
//			
//			Запись.ДоговорКонтрагента =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].ДоговорКонтрагента;
//			
//			Запись.Контрагент  =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].Контрагент;
//			
//		КонецЕсли; 
//		
//		Если  СписокОбъектов[0].Значение.ОрганизацииПодразделения.Количество() > 0 Тогда
//			
//			Запись.Подразделение  = СписокОбъектов[0].Значение.ОрганизацииПодразделения[0].Подразделение;
//			
//		КонецЕсли; 
//		
//		Запись.Сумма =  СписокОбъектов[0].Значение.СуммаДокумента;
//		
//		Запись.Инициатор   =  СсылкаНаЗадачу.Автор;
//		
//		Запись.Выполнена = СсылкаНаЗадачу.Выполнена;
//		//
//		Запрос1 = Новый Запрос;
//		Запрос1.Текст = "ВЫБРАТЬ
//		|	аДокументооборотСостояниеДокументов.СостояниеДокумента
//		|ИЗ
//		|	РегистрСведений.аДокументооборотСостояниеДокументов КАК аДокументооборотСостояниеДокументов
//		|ГДЕ
//		|	аДокументооборотСостояниеДокументов.КорпоративныйДокумент = &КорпоративныйДокумент";
//		Запрос1.УстановитьПараметр("КорпоративныйДокумент",СписокОбъектов[0].Значение );
//		Выборка1 = Запрос1.Выполнить().Выбрать();
//		Пока Выборка1.Следующий() Цикл
//			Запись.СостояниеДокумента  =  Выборка1.СостояниеДокумента;
//		КонецЦикла;
//		
//		Запись.ДатаВыполненияПлан =    СсылкаНаЗадачу.ДатаВыполненияПлан;
//		
//		Если СсылкаНаЗадачу.Выполнена Тогда
//			ЗапросРез = Новый Запрос;
//			ЗапросРез.Текст = "ВЫБРАТЬ
//			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.ПараметрРезультата.Наименование as Наименование,
//			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.ЗначениеПараметра
//			|ИЗ
//			|	РегистрСведений.аДокументооборотРезультатыИсполнителейЗадач.СрезПоследних КАК аДокументооборотРезультатыИсполнителейЗадачСрезПоследних
//			|ГДЕ
//			|	аДокументооборотРезультатыИсполнителейЗадачСрезПоследних.Задача = &Задача";
//			ЗапросРез.УстановитьПараметр("Задача",СсылкаНаЗадачу );
//			ВыборкаРез = ЗапросРез.Выполнить().Выбрать();
//			Пока ВыборкаРез.Следующий() Цикл
//				Если ВыборкаРез.Наименование = "Выбор кнопками панели" Тогда
//					Запись.Согласовано =   ВыборкаРез.ЗначениеПараметра;
//				КонецЕсли;
//				//
//				Если ВыборкаРез.Наименование = "Текстовое сообщение" Тогда
//					Запись.ТекстовыйРезультат =   ВыборкаРез.ЗначениеПараметра;
//				КонецЕсли;
//			КонецЦикла;
//			Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.ВыполненныеЗадачи;
//			Запись.ДатаВыполненияФакт   =    СсылкаНаЗадачу.ДатаВыполненияФакт;
//			//
//		Иначе
//			Запись.Согласовано =   "Не выполнена";
//			Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.НаходятсяВРаботе;
//			Запись.ТекстовыйРезультат =   "Не выполнена";
//			//
//		КонецЕсли; 
//	КонецЦикла; 
//КонецЕсли; 
//НЗ.Записать(Истина);



//Попытка
//	Если НетЗаписей Тогда
//		НЗ = РегистрыСведений.pcru_ПараметрыВыданныхЗадач.СоздатьНаборЗаписей();
//		//НЗ.Отбор.Документ.Установить(СписокОбъектов[0].Значение, Истина);
//		//НЗ.Отбор.БизнесПроцесс.Установить(СсылкаНаПроцесс, Истина);
//		НЗ.Отбор.Исполнитель.Установить(СсылкаНаЗадачу.Исполнитель, Истина);
//		НЗ.Прочитать();
//		Нашли_исполнителя = Ложь;
//		Для каждого Запись  Из НЗ Цикл
//			Если Запись.Исполнитель = СсылкаНаЗадачу.Исполнитель Тогда
//				Запись = НЗ.Добавить();
//				Запись.Задача = СсылкаНаЗадачу;
//				Запись.ВидБизнесПроцесса =  СсылкаНаЗадачу.БизнесПроцесс.ВидПроцесса;
//				Запись.БизнесПроцесс =  СсылкаНаЗадачу.БизнесПроцесс;
//				Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.НаходятсяВРаботе;
//				Запись.Документ = СписокОбъектов[0].Значение;
//				Запись.Выполнена =  СсылкаНаЗадачу.Выполнена;
//				Запись.Согласовано = "Не выполнена";
//				Запись.СостояниеДокумента = Справочники.аДокументооборотСостояниеДокументов.НаСогласовании;
//				Запись.ТекстовыйРезультат = "Не выполнена";
//				Запись.ДатаВыполненияПлан = СсылкаНаЗадачу.ДатаВыполненияПлан;
//				Запись.Исполнитель = СсылкаНаЗадачу.Исполнитель;
//				Если  СписокОбъектов[0].Значение.КонтрагентыДоговоры.Количество() > 0 Тогда
//					Запись.ДоговорКонтрагента =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].ДоговорКонтрагента;
//					Запись.Контрагент  =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].Контрагент;
//				КонецЕсли; 
//				Если  СписокОбъектов[0].Значение.ОрганизацииПодразделения.Количество() > 0 Тогда
//					Запись.Подразделение  = СписокОбъектов[0].Значение.ОрганизацииПодразделения[0].Подразделение;
//				КонецЕсли; 
//				Запись.Сумма =  СписокОбъектов[0].Значение.СуммаДокумента;
//				Запись.Инициатор   =  СсылкаНаЗадачу.Автор;
//				Запись.Выполнена = СсылкаНаЗадачу.Выполнена;	//
//				Запрос1 = Новый Запрос;
//				Запрос1.Текст = "ВЫБРАТЬ
//				|	аДокументооборотСостояниеДокументов.СостояниеДокумента
//				|ИЗ
//				|	РегистрСведений.аДокументооборотСостояниеДокументов КАК аДокументооборотСостояниеДокументов
//				|ГДЕ
//				|	аДокументооборотСостояниеДокументов.КорпоративныйДокумент = &КорпоративныйДокумент";
//				Запрос1.УстановитьПараметр("КорпоративныйДокумент",СписокОбъектов[0].Значение );
//				Выборка1 = Запрос1.Выполнить().Выбрать();
//				Пока Выборка1.Следующий() Цикл
//					Запись.СостояниеДокумента  =  Выборка1.СостояниеДокумента;
//				КонецЦикла;
//				Запись.ДатаВыполненияПлан =    СсылкаНаЗадачу.ДатаВыполненияПлан;
//				Нашли_исполнителя = Истина;
//			КонецЕсли;   	
//		КонецЦикла; 
//		
//		Если не Нашли_исполнителя Тогда
//			Запись = НЗ.Добавить();
//			Запись.Задача = СсылкаНаЗадачу;
//			Запись.ВидБизнесПроцесса =  СсылкаНаЗадачу.БизнесПроцесс.ВидПроцесса;
//			Запись.БизнесПроцесс =  СсылкаНаЗадачу.БизнесПроцесс;
//			Запись.ТипЗадач = Перечисления.аГруппировкиЗадач.НаходятсяВРаботе;
//			Запись.Документ = СписокОбъектов[0].Значение;
//			Запись.Выполнена =  СсылкаНаЗадачу.Выполнена;
//			Запись.Согласовано = "Не выполнена";
//			Запись.СостояниеДокумента = Справочники.аДокументооборотСостояниеДокументов.НаСогласовании;
//			Запись.ТекстовыйРезультат = "Не выполнена";
//			Запись.ДатаВыполненияПлан = СсылкаНаЗадачу.ДатаВыполненияПлан;
//			Запись.Исполнитель = СсылкаНаЗадачу.Исполнитель;
//			Если  СписокОбъектов[0].Значение.КонтрагентыДоговоры.Количество() > 0 Тогда
//				Запись.ДоговорКонтрагента =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].ДоговорКонтрагента;
//				Запись.Контрагент  =  СписокОбъектов[0].Значение.КонтрагентыДоговоры[0].Контрагент;
//			КонецЕсли; 
//			Если  СписокОбъектов[0].Значение.ОрганизацииПодразделения.Количество() > 0 Тогда
//				Запись.Подразделение  = СписокОбъектов[0].Значение.ОрганизацииПодразделения[0].Подразделение;
//			КонецЕсли; 
//			Запись.Сумма =  СписокОбъектов[0].Значение.СуммаДокумента;
//			Запись.Инициатор   =  СсылкаНаЗадачу.Автор;
//			Запись.Выполнена = СсылкаНаЗадачу.Выполнена;	//
//			Запрос1 = Новый Запрос;
//			Запрос1.Текст = "ВЫБРАТЬ
//			|	аДокументооборотСостояниеДокументов.СостояниеДокумента
//			|ИЗ
//			|	РегистрСведений.аДокументооборотСостояниеДокументов КАК аДокументооборотСостояниеДокументов
//			|ГДЕ
//			|	аДокументооборотСостояниеДокументов.КорпоративныйДокумент = &КорпоративныйДокумент";
//			Запрос1.УстановитьПараметр("КорпоративныйДокумент",СписокОбъектов[0].Значение );
//			Выборка1 = Запрос1.Выполнить().Выбрать();
//			Пока Выборка1.Следующий() Цикл
//				Запись.СостояниеДокумента  =  Выборка1.СостояниеДокумента;
//			КонецЦикла;
//			Запись.ДатаВыполненияПлан =    СсылкаНаЗадачу.ДатаВыполненияПлан;
//		КонецЕсли; 
//		НЗ.Записать(Истина);
//	КонецЕсли; 	
//Исключение
//КонецПопытки;
//


