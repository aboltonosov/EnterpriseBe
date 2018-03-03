﻿
&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",
		Новый Структура("НастройкаПроксиНаКлиенте", Истина),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПравила(Команда)
	ОткрытьФорму("РегистрСведений.ПравилаЗаполненияПолейЭСЧФ.ФормаСписка");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьПравилаНаСервере()
	
	РегистрыСведений.ПравилаЗаполненияПолейЭСЧФ.ЗагрузитьПравилаИзМакета();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПравила(Команда)
	
	ОбновитьПравилаНаСервере();
	
	ТекстСообщения = НСтр("ru='Правила заполнения полей ЭСЧФ обновлены.'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти


