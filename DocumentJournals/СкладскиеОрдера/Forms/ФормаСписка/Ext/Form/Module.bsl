﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	(Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			ИЛИ Склады.ИспользоватьОрдернуюСхемуПриПоступлении)
	|	И Склады.ЭтоГруппа = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склады.Наименование");
	ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрВыбора(Элементы.Склад, "Ссылка", Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад"));

	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	СкладПомещениеПриИзмененииСервер();
	
	Элементы.ЖурналОрдеровСоздатьВозвратНепринятыхТоваров.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ПриходныйОрдерНаТовары);
	Элементы.ЖурналОрдеровСоздатьОрдерНаПеремещение.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ОрдерНаПеремещениеТоваров);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ЖурналОрдеровКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.СоздатьНаОсновании);
	// Конец ВводНаОсновании
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ЖурналОрдеров.Дата", Элементы.ЖурналОрдеровДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СкладПомещениеПриИзмененииСервер();
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЖурналОрдеров

&НаКлиенте
Процедура ЖурналОрдеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	Если ИспользоватьСкладскиеПомещения Тогда
		СоздатьОрдерНаПеремещениеКлиент();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЖурналОрдеровПриАктивизацииСтроки(Элемент)
	
	УправлениеПечатьюКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.ЖурналОрдеров);
	
КонецПроцедуры
// Конец ВводНаОсновании

&НаКлиенте
Процедура СоздатьОрдерНаПеремещение(Команда)
	
	СоздатьОрдерНаПеремещениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратНепринятыхТоваров(Команда)
	
	Основание = Новый Структура;
	Основание.Вставить("Склад", Склад);
	Основание.Вставить("Помещение", Помещение);
	Основание.Вставить("СкладскаяОперация", ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ВозвратНепринятыхТоваров"));
	ОткрытьФорму("Документ.ПриходныйОрдерНаТовары.Форма.ФормаДокумента", Новый Структура("Основание",Основание));
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ЖурналОрдеров);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УправлениеПечатьюКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ЖурналОрдеров);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ЖурналОрдеров);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПомещение;
	Иначе
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Неопределено));
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПустая;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЖурналОрдеровСтатус", "Видимость",
		СкладыСервер.ИспользоватьСтатусыОрдеров(Склад));
	
	ИспользоватьСкладскиеПомещения = СкладыСервер.ИспользоватьСкладскиеПомещения(Склад);
	ИспользоватьОтборПоПомещению   = ЗначениеЗаполнено(Помещение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЖурналОрдеров, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(ЖурналОрдеров).Элементы, "ОтборПоПомещению",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
																					
	Если Не ИспользоватьОтборПоПомещению Тогда
		ГруппаЭлементовОтбора.Использование = Ложь;
	Иначе
		ГруппаЭлементовОтбора.Использование = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаЭлементовОтбора, "ПомещениеОтправитель", Помещение,
															ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаЭлементовОтбора, "ПомещениеПолучатель", Помещение,
															ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриходныйОрдерНаТовары.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.РасходныйОрдерНаТовары.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаПеремещениеТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.ЖурналОрдеров.ТекущаяСтрока = Ссылка;
		
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СоздатьОрдерНаПеремещениеКлиент()
	
	Основание = Новый Структура;
	Основание.Вставить("Склад", Склад);
	Основание.Вставить("ПомещениеОтправитель", Помещение);
	
	ОткрытьФорму("Документ.ОрдерНаПеремещениеТоваров.Форма.ФормаДокумента",Новый Структура("Основание",Основание));
	
КонецПроцедуры

#КонецОбласти