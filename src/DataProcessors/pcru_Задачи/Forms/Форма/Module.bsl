
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПараметрыСписковЗадач();
КонецПроцедуры
&НаСервере
Процедура УстановитьПараметрыСписковЗадач()
	
	ЭтаФорма.СписокПолученныеЗадачи.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	ЭтаФорма.СписокВыданныеЗадачи.Параметры.УстановитьЗначениеПараметра("Пользователь",  ПараметрыСеанса.ТекущийПользователь);	
	
	ЭтаФорма.ДокументыПользователяТекущие.Параметры.УстановитьЗначениеПараметра("Пользователь",  ПараметрыСеанса.ТекущийПользователь);	
	ЭтаФорма.ДокументыПользователяТекущие.Параметры.УстановитьЗначениеПараметра("СостояниеДокумента", Справочники.аДокументооборотСостояниеДокументов.НаСогласовании);	
	ЭтаФорма.ДокументыПользователяТекущие.Параметры.УстановитьЗначениеПараметра("СостояниеДокумента1", Справочники.аДокументооборотСостояниеДокументов.НайтиПоНаименованию("Не согласован"));	
	
	
	ЭтаФорма.Заместители.Параметры.УстановитьЗначениеПараметра("Сотрудник",  ПараметрыСеанса.ТекущийПользователь);	
	ЭтаФорма.МатрицаЗаместителей.Параметры.УстановитьЗначениеПараметра("Сотрудник",  ПараметрыСеанса.ТекущийПользователь);	
	
	ЭтаФорма.МатрицаЗаместителей.Параметры.УстановитьЗначениеПараметра("ТекДата",  ТекущаяДата());	
	
	ЭтаФорма.ДокументыПодразделения.Параметры.УстановитьЗначениеПараметра("ОсновноеПодразделение", Справочники.Подразделения.ПустаяСсылка());
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодразделенияСотрудники.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Подразделения.Сотрудники КАК ПодразделенияСотрудники
	|ГДЕ
	|	ПодразделенияСотрудники.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь",  ПараметрыСеанса.ТекущийПользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЭтаФорма.ДокументыПодразделения.Параметры.УстановитьЗначениеПараметра("ОсновноеПодразделение", Выборка.ссылка);
	КонецЦикла;
	ЭтаФорма.ДокументыПодразделения.Параметры.УстановитьЗначениеПараметра("СостояниеДокумента", Справочники.аДокументооборотСостояниеДокументов.НаСогласовании);
КонецПроцедуры

&НаСервере
Процедура ПользовательПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	УстановитьПараметрыСписковЗадач();
КонецПроцедуры


&НаКлиенте
Процедура СписокПолученныеЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	П = Новый Структура("Ключ", ЭтаФорма.Элементы.СписокПолученныеЗадачи.ТекущиеДанные.Задача);
	
	
	ОткрытьФорму("Задача.аДокументооборотЗадача.ФормаОбъекта",П); 
	
КонецПроцедуры


&НаКлиенте
Процедура СписокВыданныеЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	П = Новый Структура("Ключ", ЭтаФорма.Элементы.СписокВыданныеЗадачи.ТекущиеДанные.Документ);
	
	
	ОткрытьФорму("Задача.аДокументооборотЗадача.ФормаОбъекта",П); 
	
	
КонецПроцедуры

&НаСервере
Процедура ВнестиЗаместителяНаСервере(СсылкаНаСпр)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	pcru_ЗаместителиСотрудника.Ссылка
	|ИЗ
	|	Справочник.pcru_ЗаместителиСотрудника КАК pcru_ЗаместителиСотрудника
	|ГДЕ
	|	pcru_ЗаместителиСотрудника.Сотрудник = &Сотрудник";
	Запрос.УстановитьПараметр("Сотрудник",ПараметрыСеанса.ТекущийПользователь );
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СсылкаНаСпр = Выборка.Ссылка;
		Возврат;
	КонецЦикла;
	Спроб = Справочники.pcru_ЗаместителиСотрудника.СоздатьЭлемент();
	Спроб.Сотрудник = ПараметрыСеанса.ТекущийПользователь;
	Спроб.Записать();
	СсылкаНаСпр = Спроб.Ссылка;
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ВнестиЗаместителя(Команда)
	СсылкаНаСпр = Неопределено;
	ВнестиЗаместителяНаСервере(СсылкаНаСпр);
	ПоказатьЗначение(,СсылкаНаСпр);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДокументыПОльзователя(Команда)
	Элементы.ДокументыПользователяТекущие.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	//ТекстПредупреждения = "Все редактируемые файлы будут закрыты.";
	//ПодключитьОбработчикОжидания("ПередЗавершениемРаботыСистемыПодключаемая",0.5,Истина);
	//Отказ =  Истина;
КонецПроцедуры

//&НаКлиенте
//Процедура ПередЗавершениемРаботыСистемыПодключаемая() Экспорт
//	pcru_РаботаСДокументами.ЗакрытьВсеФайлы();//PCRU_MF!
//КонецПроцедуры
