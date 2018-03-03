﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ОтборПоСпискуЗаказов") Тогда
		ОтборПоСпискуЗаказов(Параметры.ОтборПоСпискуЗаказов);
	//++ НЕ УТКА
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтаповГрафика") Тогда
		ОтборПоСпискуЭтаповГрафика(Параметры.ОтборПоСпискуЭтаповГрафика);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтапов") Тогда
		ОтборПоСпискуЭтапов(Параметры.ОтборПоСпискуЭтапов);
	//-- НЕ УТКА
	КонецЕсли; 
	
	ПравоДоступаДобавление = ПравоДоступа("Добавление", Метаданные.Документы.ЗаказПереработчику);
	ИспользоватьРасширенноеОбеспечениеПотребностей = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
	
	Если ИспользоватьРасширенноеОбеспечениеПотребностей Тогда
		Элементы.ФормаСписокГруппаСоздать.Видимость = ПравоДоступаДобавление;
		Элементы.СписокСоздать.Видимость = Ложь;
	Иначе
		Элементы.ФормаСписокГруппаСоздать.Видимость = Ложь;
		Элементы.СписокСоздать.Видимость = ПравоДоступаДобавление;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаказПереработчику));
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(ПодключаемоеОборудованиеУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("НеЗагружатьОтборы") Тогда
		Настройки.Удалить("Менеджер");
		Настройки.Удалить("Приоритет");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер  = Настройки.Получить("Менеджер");
	Приоритет = Настройки.Получить("Приоритет");
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подразделение",  ОтборПодразделение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПодразделение));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Менеджер",  Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подразделение",  ОтборПодразделение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Менеджер",  Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));

КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Условное оформление динамического списка "Список"
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// Документ имеет высокий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Документ имеет высокий приоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьВысшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ВысокийПриоритетДокумента);
	
	// Документ имеет низкий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Документ имеет низкий приоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьНизшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.НизкийПриоритетДокумента);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);

	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПереработчику.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЗаказов(СписокЗаказов)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказПереработчику.Ссылка
	|ИЗ
	|	Документ.ЗаказПереработчику КАК ЗаказПереработчику
	|ГДЕ
	|	ЗаказПереработчику.Распоряжение В (&СписокЗаказов)";
	
	Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Заказы переработчикам (установлен отбор по заказам)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

//++ НЕ УТКА

&НаСервере
Процедура ОтборПоСпискуЭтаповГрафика(СписокЭтапов)

	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиЭтапыГрафик", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	КодСтрокиЭтапыГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЗаказПереработчику.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Услуги КАК ЗаказПереработчику
	|		ПО (ЗаказПереработчику.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (ЗаказПереработчику.КодСтрокиПродукция = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (ЗаказПереработчику.КодСтрокиЭтапыГрафик = ТаблицаЭтапов.КодСтрокиЭтапыГрафик)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Заказы переработчикам (установлен отбор по этапам)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЭтапов(СписокЭтапов)

	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыПроизводства"));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.Этап КАК Этап
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	Этап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЗаказПереработчику.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Услуги КАК ЗаказПереработчику
	|		ПО (ЗаказПереработчику.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (ЗаказПереработчику.КодСтрокиПродукция = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (ЗаказПереработчику.Этап = ТаблицаЭтапов.Этап)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	СписокДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru = 'Заказы переработчикам (установлен отбор по этапам)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти
