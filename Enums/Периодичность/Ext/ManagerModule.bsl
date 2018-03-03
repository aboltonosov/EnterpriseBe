﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ НЕ УТ

#Область ПрограммныйИнтерфейс

// Возвращает упорядоченный массив периодичностей.
//
// Возвращаемое значение:
// 	 Массив или ТаблицаЗначений - периодичности от "мелкой" к "крупной"
//
// Параметры:
// 	 ВозвращатьВВидеТаблицы - если Истина - то возвращает таблицу значений
//
Функция УпорядоченныеПериодичности(ВозвращатьВВидеТаблицы = Ложь) Экспорт
	
	Периодичности = БюджетнаяОтчетностьКлиентСервер.УпорядоченныеПериодичности();
	
	Если ВозвращатьВВидеТаблицы Тогда
		ТаблицаПериодичности = Новый ТаблицаЗначений;
		ТаблицаПериодичности.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
		ТаблицаПериодичности.Колонки.Добавить("Периодичность", Новый ОписаниеТипов("ПеречислениеСсылка.Периодичность"));
		Для Каждого Периодичность из Периодичности Цикл
			НоваяСтрокаПериодичность = ТаблицаПериодичности.Добавить();
			НоваяСтрокаПериодичность.Периодичность = Периодичность;
			НоваяСтрокаПериодичность.Порядок = ТаблицаПериодичности.Индекс(НоваяСтрокаПериодичность);
		КонецЦикла;
		Периодичности = ТаблицаПериодичности;
	КонецЕсли;
	
	Возврат Периодичности;
	
КонецФункции

// Возвращает количество подпериодов в периоде
//
// Параметры:
// 	Периодичность - Периодичность, для которой определяется количество подпериодов
// 	ПериодичностьПодПериодов - Периодичность, количество периодов которой надо найти
// 
// Возвращаемое значение:
// 	Результат - Число - Найденное количество периодов
//
Функция КоличествоПериодов(Периодичность, ПериодичностьПодПериодов) Экспорт
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	Источник = Новый ОписаниеИсточникаДанных(ПолучитьМакет("СоотношениеПериодов").Область("Соотношения"));
	ПостроительЗапроса.ИсточникДанных = Источник;
	ПостроительЗапроса.Выполнить();
	Таблица = ПостроительЗапроса.Результат.Выгрузить();
	
	ИмяСтроки = ОбщегоНазначения.ИмяЗначенияПеречисления(Периодичность);
	ИмяКолонки = ОбщегоНазначения.ИмяЗначенияПеречисления(ПериодичностьПодПериодов);
	
	Возврат Число(Таблица.Найти(ИмяСтроки, "Заголовок")[ИмяКолонки]);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сценарий") Тогда
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		
		Сценарии = Новый Массив;
		Сценарии.Добавить(Параметры.Сценарий);
		Если Параметры.Свойство("СценарийДляСравнения") Тогда
			Сценарии.Добавить(Параметры.СценарийДляСравнения);
		КонецЕсли;
		
		ПериодичностиСценариев = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сценарии, "Периодичность");
		ПериодичностиПоПорядку = УпорядоченныеПериодичности();
		
		ИндексДляОтбора = 0;
		Для каждого Элемент Из ПериодичностиСценариев Цикл
			
			Индекс = ПериодичностиПоПорядку.Найти(Элемент.Значение);
			Если Индекс > ИндексДляОтбора Тогда
				ИндексДляОтбора = Индекс;
			КонецЕсли;
			
		КонецЦикла;
		
		Для Индекс = ИндексДляОтбора По ПериодичностиПоПорядку.Количество() - 1 Цикл
			ДанныеВыбора.Добавить(ПериодичностиПоПорядку.Получить(Индекс));
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- НЕ УТ

#КонецЕсли