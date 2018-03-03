﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтборТаможенныхДеклараций = 0; // Показывать все таможенные декларации
	
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	ОбновитьДанныеФормы();
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	УстановитьВидимостьДоступностьЭлементов();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ТаможенныеДекларации", "ТаможенныеДекларацииДата");
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "КОформлению", "КОформлениюДатаРеализации");
	
	КОформлениюКоличество = ПолучитьКоличествоДокументовКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборТаможенныхДеклараций();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ТаможеннаяДекларацияЭкспорт"
		Или ИмяСобытия = "Запись_РеализацияТоваровУслуг" Тогда
		
		ЭтаФорма.Элементы.ТаможенныеДекларации.Обновить();
		ЭтаФорма.Элементы.КОформлению.Обновить();
		КОформлениюКоличество = ПолучитьКоличествоДокументовКОформлению();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	Если ОрганизацияСохраненноеЗачение <> ОрганизацияОтбор Тогда
		
		УстановитьОтборыПоОрганизации();
		ОрганизацияСохраненноеЗачение = ОрганизацияОтбор;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КОформлению,
		"Контрагент",
		Контрагент,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРеализацииПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КОформлению,
		"ДатаРеализации",
		ДатаРеализации,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ДатаРеализации));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЭтаФорма.Элементы.ТаможенныеДекларации.Обновить();
	ЭтаФорма.Элементы.КОформлению.Обновить();
	КОформлениюКоличество = ПолучитьКоличествоДокументовКОформлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура ОтборТаможенныхДекларацийПриИзменении(Элемент)
	
	УстановитьОтборТаможенныхДеклараций();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.КОформлению.ДанныеСтроки(ВыбраннаяСтрока);
	ПоказатьЗначение(Неопределено, ДанныеСтроки.РеализацияЭкспорт);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьТаможеннуюДекларациюЭкспорт(Команда)
	
	СформироватьДокументыНаОсновании();
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ТаможенныеДекларации);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборыПоОрганизации()
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(СписокТаможенныеДекларацииЭкспорт);
	МассивСписков.Добавить(КОформлению);
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(ОрганизацияОтбор);
	
	Если ЗначениеЗаполнено(ОрганизацияОтбор)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", ОрганизацияОтбор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ДинамическийСписок Из МассивСписков Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(ОрганизацияОтбор));
	КонецЦикла;
	
	КОформлениюКоличество = ПолучитьКоличествоДокументовКОформлению();
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборТаможенныхДеклараций()
	
	Если ОтборТаможенныхДеклараций = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокТаможенныеДекларацииЭкспорт,
				"СборСопроводительныхДокументовЗавершен",
				Ложь,
				ВидСравненияКомпоновкиДанных.Равно,
				,
				Истина);
	ИначеЕсли ОтборТаможенныхДеклараций = 2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокТаможенныеДекларацииЭкспорт,
				"СборСопроводительныхДокументовЗавершен",
				Истина,
				ВидСравненияКомпоновкиДанных.Равно,
				,
				Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокТаможенныеДекларацииЭкспорт,
				"СборСопроводительныхДокументовЗавершен",
				Ложь,
				ВидСравненияКомпоновкиДанных.Равно,
				,
				Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ОрганизацияОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ТаможенныеДекларацииОрганизация.Видимость = Не ЗначениеЗаполнено(ОрганизацияОтбор);
	Элементы.КОформлениюОрганизация.Видимость          = Не ЗначениеЗаполнено(ОрганизацияОтбор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", ОрганизацияОтбор);
		СтруктураБыстрогоОтбора.Свойство("ОтборТаможенныхДеклараций", ОтборТаможенныхДеклараций);
	КонецЕсли;
	Если Параметры.Свойство("ОтображатьСтраницуКОформлению") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументыНаОсновании();
	
	Список = Элементы.КОформлению;
	ТекущаяСтрока = Список.ТекущиеДанные;

	Если ТекущаяСтрока = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если Список.ВыделенныеСтроки.Количество() = 1 Тогда
		
		Если ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ДокументОснование = ТекущаяСтрока.РеализацияЭкспорт;
		ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.ФормаОбъекта", Новый Структура("Основание", ДокументОснование), , Истина);
		
	Иначе
		
		МассивРеализаций = Новый Массив();
		
		Для Каждого ВыделеннаяСтрока Из Список.ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			МассивРеализаций.Добавить(Список.ДанныеСтроки(ВыделеннаяСтрока).РеализацияЭкспорт);
		КонецЦикла;
		
		Если МассивРеализаций.Количество() = 0 Тогда
			ТекстПредупреждения = НСтр("ru = 'Не выбрано ни одного документа для ввода на основании!'");
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		СоответствиеОрганизаций = ПолучитьОрганизациииПоРеализациям(МассивРеализаций);
		Для каждого Элемент Из СоответствиеОрганизаций Цикл
			
			ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.ФормаОбъекта", Новый Структура("Основание", Элемент.Значение), , Истина);
		
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОрганизациииПоРеализациям(МассивРеализаций)
	
		Соответствие = Новый Соответствие;
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Организация КАК Организация,
		|	РеализацияТоваровУслуг.Ссылка КАК РеализацияЭкспорт
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Ссылка В(&МассивСсылок)
		|ИТОГИ ПО
		|	Организация";
		Запрос.УстановитьПараметр("МассивСсылок", МассивРеализаций);
		
		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Организация");
		Пока Выборка.Следующий() Цикл
			
			РеализацииПоОрганизации = Новый Массив;
			ВыборкаПоСсылкам = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Пока ВыборкаПоСсылкам.Следующий() Цикл
				РеализацииПоОрганизации.Добавить(ВыборкаПоСсылкам.РеализацияЭкспорт);
			КонецЦикла;
			
			Соответствие.Вставить(Выборка.Организация, РеализацииПоОрганизации);
			
		КонецЦикла;
		
		Возврат Соответствие;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	УстановитьОтборыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоДокументовКОформлению() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Записи.РеализацияЭкспорт) КАК КоличествоЗаписей
	|ИЗ
	|	РегистрСведений.ТаможенныеДекларацииЭкспортКРегистрации КАК Записи
	|ГДЕ
	|	(Записи.Организация = &Организация
	|		ИЛИ &ПоВсемОрганизациям)";
	
	Запрос.УстановитьПараметр("Организация", ОрганизацияОтбор);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", Не ЗначениеЗаполнено(ОрганизацияОтбор));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЗаписей;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции


#КонецОбласти