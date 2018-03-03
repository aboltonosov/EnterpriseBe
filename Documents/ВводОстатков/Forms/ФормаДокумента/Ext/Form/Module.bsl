﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	Если Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() > 0 Тогда
		СписокТиповОпераций.ЗагрузитьЗначения(Параметры.ОтборПоТипамОпераций.ВыгрузитьЗначения());
		СписокТиповОпераций.СортироватьПоЗначению();
	Иначе
		Документы.ВводОстатков.ПолучитьСписокТиповОпераций(СписокТиповОпераций);
		СписокТиповОпераций.СортироватьПоЗначению();
	КонецЕсли;
	
	Для Каждого АрхивныйТипОперации Из Документы.ВводОстатков.ПолучитьСписокАрхивныхТиповОпераций() Цикл
		НайденноеЗначение = СписокТиповОпераций.НайтиПоЗначению(АрхивныйТипОперации);
		Если НЕ НайденноеЗначение = Неопределено Тогда
			СписокТиповОпераций.Удалить(НайденноеЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("РазделУчета") Тогда
		Объект.РазделУчета = Параметры.РазделУчета;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Модифицированность = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписоктиповопераций

&НаКлиенте
Процедура СписокТиповОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТипаОперации()

	СтрокаТаблицы = Элементы.СписокТиповОпераций.ТекущиеДанные;
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ТипОперации",              СтрокаТаблицы.Значение);
		ЗначенияЗаполнения.Вставить("Организация",              Объект.Организация);
		ЗначенияЗаполнения.Вставить("РазделУчета",              Объект.РазделУчета);
		Модифицированность = Ложь;
		ОткрытьФорму("Документ.ВводОстатков.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ВладелецФормы, );//КлючИзПараметров
		Закрыть();
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура ВыбратьТипОперации(Команда)

	ОбработкаВыбораТипаОперации();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
