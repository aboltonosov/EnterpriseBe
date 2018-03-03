﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаЗначений.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.ТаблицаЗначений.ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		Закрыть(Неопределено);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТаблицаЗначений.Количество() > 0 Тогда
		
		Элементы.ТаблицаЗначений.ТекущаяСтрока = ИдентификаторНайденнойСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.ТаблицаЗначений.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.НаимКолонкиКод) Тогда
		
		Элементы.ТаблицаЗначенийКод.Заголовок = Параметры.НаимКолонкиКод;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаимКолонкиНазвание) Тогда
		
		Элементы.ТаблицаЗначенийНазвание.Заголовок = Параметры.НаимКолонкиНазвание;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти