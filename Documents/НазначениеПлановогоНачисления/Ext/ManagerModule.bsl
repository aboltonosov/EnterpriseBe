﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИдентификаторыСтрокСотрудников() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НазначениеПлановогоНачисленияСотрудники.Ссылка
		|ИЗ
		|	Документ.НазначениеПлановогоНачисления.Сотрудники КАК НазначениеПлановогоНачисленияСотрудники
		|ГДЕ
		|	НазначениеПлановогоНачисленияСотрудники.ИдентификаторСтрокиСотрудника = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			ИдентификаторыСотрудников = Новый Соответствие;
			МаксимальныйИдентификаторСтрокиСотрудника = 1;
			Для каждого СтрокаСотрудника Из ДокументОбъект.Сотрудники Цикл
				
				СтрокаСотрудника.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
				ИдентификаторыСотрудников.Вставить(СтрокаСотрудника.Сотрудник, СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
				
				МаксимальныйИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника + 1;
				
			КонецЦикла;
			
			Для каждого СтрокаПоказателя Из ДокументОбъект.ПоказателиСотрудников Цикл
				СтрокаПоказателя.ИдентификаторСтрокиСотрудника = ИдентификаторыСотрудников.Получить(СтрокаПоказателя.УдалитьСотрудник);
			КонецЦикла;
			
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли