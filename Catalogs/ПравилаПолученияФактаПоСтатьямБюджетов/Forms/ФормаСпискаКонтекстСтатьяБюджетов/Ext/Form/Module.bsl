﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтатьяБюджетов = Параметры.СтатьяБюджетов;
	ТипПравил = Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ФактическиеДанные;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтатьяБюджетов", СтатьяБюджетов);
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПравилПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Новый Структура("СтатьяБюджетов, ТипПравила", СтатьяБюджетов, ТипПравил));
	ОткрытьФорму("Справочник.ПравилаПолученияФактаПоСтатьямБюджетов.Форма.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма,,,,,
																		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	СписокТиповПравила = Новый СписокЗначений;
	СписокТиповПравила.Добавить(Перечисления.ТипПравилаПолученияФактическихДанныхБюджетирования.ИсполнениеБюджетаИФактическиеДанные);
	
	СписокТиповПравила.Добавить(ТипПравил);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"ТипПравила", СписокТиповПравила,
																			ВидСравненияКомпоновкиДанных.ВСписке, Истина);
	
КонецПроцедуры

#КонецОбласти


