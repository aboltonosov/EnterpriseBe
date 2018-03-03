﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("Метаданные", "ОбработкаОтветовЕГАИС");
		
		Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
		Если Задания.Количество() <> 1 Тогда
			ЗаписьЖурналаРегистрации(
				ИнтеграцияЕГАИСКлиентСервер.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегламентныеЗадания.ОбработкаОтветовЕГАИС,,
				НСтр("ru='Не найдено регламентное задание обработки ответов ЕГАИС'"));
			Возврат;
		КонецЕсли;
		
		Задание = Задания[0];
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Значение);
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание.УникальныйИдентификатор, ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
