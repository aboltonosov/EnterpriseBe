﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоТипу = Неопределено;
	Параметры.Свойство("ОтборПоТипу", ОтборПоТипу);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтборПоТипу", ОтборПоТипу);
	
	Если ОтборПоТипу = "Организации" Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru = 'Организация'");
		Заголовок = НСтр("ru = 'История регистрации организации в налоговых органах'");
	ИначеЕсли ОтборПоТипу = "Подразделения" Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru = 'Регламентированное подразделение'");
		Заголовок = НСтр("ru = 'История регистрации регламентированных подразделений организации в налоговых органах'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("РегистрСведений.ИсторияРегистрацийВНалоговомОргане.Форма.ФормаЗаписиУП", Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока));
	
КонецПроцедуры

#КонецОбласти
