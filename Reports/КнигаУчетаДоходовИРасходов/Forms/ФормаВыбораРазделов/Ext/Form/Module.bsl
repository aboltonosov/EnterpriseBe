﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("НастройкиПечатныхФорм") Тогда
		НастройкиПечатныхФорм.Загрузить(Параметры.НастройкиПечатныхФорм.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкиПечатныхФормПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОповеститьОВыборе(НастройкиПечатныхФорм);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	УстановитьСнятьФлажки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	УстановитьСнятьФлажки(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСнятьФлажки(Пометка)
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		НастройкаПечатнойФормы.Печатать = Пометка;
		Если Пометка И НастройкаПечатнойФормы.Количество = 0 Тогда
			НастройкаПечатнойФормы.Количество = 1;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти