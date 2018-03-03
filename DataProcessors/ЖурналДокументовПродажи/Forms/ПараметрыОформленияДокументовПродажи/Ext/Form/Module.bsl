﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СтруктураПараметров = ПолучитьПараметры(Параметры);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПараметров);
	
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры И НЕ ЗавершениеРаботы Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Параметры были изменены. Закрыть форму без сохранения параметров?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеЗакрывать" Тогда
		
		СохранитьПараметры = Ложь;
		
	ИначеЕсли ОтветНаВопрос = "Закрыть" Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		СохранитьПараметры = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьПараметры = Истина;
	Закрыть(ПолучитьПараметры(ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПараметры(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ПечататьАктВыполненныхРабот",    Источник.ПечататьАктВыполненныхРабот);
	СтруктураПараметров.Вставить("ПечататьРеализациюТоваровУслуг", Источник.ПечататьРеализациюТоваровУслуг);
	СтруктураПараметров.Вставить("СоздаватьДокументПродажи",       Источник.СоздаватьДокументПродажи);
	СтруктураПараметров.Вставить("СоздаватьСчетФактуру",           Источник.СоздаватьСчетФактуру);
	СтруктураПараметров.Вставить("НеОткрыватьФормуСозданногоДокумента", Источник.НеОткрыватьФормуСозданногоДокумента);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзменениеФлага(Реквизит, ЗависимыйЭлемент, ЗависимыйРеквизит  = Неопределено)
	
	ЗависимыйЭлемент.Доступность = Реквизит;
	Если Не Реквизит И ЗависимыйЭлемент <> Неопределено Тогда
		 ЗависимыйРеквизит = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьДокументаПродажи(Форма)
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.ПечататьРеализацию,
		Форма.ПечататьРеализациюТоваровУслуг);
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.ПечататьАкт,
		Форма.ПечататьАктВыполненныхРабот);
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.СоздаватьСчетФактуру,
		Форма.СоздаватьСчетФактуру);
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.НеОткрыватьФормуСозданногоДокумента,
		Форма.НеОткрыватьФормуСозданногоДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьДокументПродажиПриИзменении(Элемент)
	
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
