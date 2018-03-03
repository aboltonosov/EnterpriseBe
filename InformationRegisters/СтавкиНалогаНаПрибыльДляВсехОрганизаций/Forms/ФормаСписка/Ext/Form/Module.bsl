﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ОбработкаОбновленияФормы()
	
	Элементы.ГруппаСтавкиВБюджетСубъектовРФ.Видимость = ПрименяютсяРазныеСтавкиНалогаНаПрибыль;
	Элементы.СтавкиДляВсехОрганизацийСтавкаСубъектРФ.Видимость = Не ПрименяютсяРазныеСтавкиНалогаНаПрибыль;
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПрименяютсяРазныеСтавкиНалогаНаПрибыльПриИзменении(Элемент)
	
	УстановитьПризнакПримененияРазныхСтавокНалогаНаПрибыль();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПрименяютсяРазныеСтавкиНалогаНаПрибыль = ПолучитьФункциональнуюОпцию("ПрименяютсяРазныеСтавкиНалогаНаПрибыль");
	ОбработкаОбновленияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьФорму" Тогда
		ОбработкаОбновленияФормы();
	КонецЕсли; 
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьПризнакПримененияРазныхСтавокНалогаНаПрибыль()
	
	Константы.ПрименяютсяРазныеСтавкиНалогаНаПрибыль.Установить(ПрименяютсяРазныеСтавкиНалогаНаПрибыль);
	ОбработкаОбновленияФормы();
	
КонецПроцедуры
