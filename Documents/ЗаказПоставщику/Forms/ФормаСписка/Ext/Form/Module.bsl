﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	ИспользоватьПоступлениеПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам");
	УстановитьВидимостьЭлементов();
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаказПоставщику));
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец подсистема "ОбменСКонтрагентами".
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
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
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер  = Настройки.Получить("Менеджер");
	Приоритет = Настройки.Получить("Приоритет");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер",  Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер",  Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));

КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Не согласован"". По принятым в работу заказам могут быть оформлены документы. Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласован");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласован'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласован(Команда)

	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Согласован"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусСогласованЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласованЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Согласован");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Согласован'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПодтвержден(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""Подтвержден"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусПодтвержденЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПодтвержденЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Подтвержден");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Подтвержден'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСтроки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

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

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка"));
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
Процедура УстановитьВидимостьЭлементов()
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ГруппаУстановитьСтатус");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовПоставщикам"));
	
КонецПроцедуры

//Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#КонецОбласти
