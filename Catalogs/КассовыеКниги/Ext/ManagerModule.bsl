﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет переданный список кассовыми книгами, доступными организации
//
// Параметры:
//    Организация - СправочникСсылка.Организации - Организация, по которой производится поиск кассовых книг
//    СписокКассовыхКниг - СписокЗначений - Заполняемый список
//
Процедура КассовыеКнигиОрганизации(Организация, СписокКассовыхКниг) Экспорт
	
	СписокКассовыхКниг.Очистить();
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если ЗначениеЗаполнено(Организация) ИЛИ НЕ ИспользоватьНесколькоОрганизаций Тогда
		
		СписокКассовыхКниг.Добавить(ПустаяСсылка(), НСтр("ru = '<Основная кассовая книга организации>'"));
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	КассовыеКниги.Ссылка КАК КассоваяКнига
		|ИЗ
		|	Справочник.КассовыеКниги КАК КассовыеКниги
		|ГДЕ
		|	(КассовыеКниги.Владелец = &Организация ИЛИ НЕ &ОтбиратьПоОрганизации)
		|");
		
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ОтбиратьПоОрганизации", ИспользоватьНесколькоОрганизаций);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокКассовыхКниг.Добавить(Выборка.КассоваяКнига);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли