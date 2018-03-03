﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключает внешнюю обработку (отчет).
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку().
//
Функция ПодключитьВнешнююОбработку(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку(Ссылка);
	
КонецФункции

// Создает и возвращает экземпляр внешней обработки (отчета).
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки().
//
Функция ОбъектВнешнейОбработки(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(Ссылка);
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ОбъектВнешнейОбработки.
// Создает и возвращает экземпляр внешней обработки (отчета).
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки().
//
Функция ПолучитьОбъектВнешнейОбработки(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(Ссылка);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет команду обработки и помещает результат во временное хранилище.
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ВыполнитьКоманду().
//
Функция ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата = Неопределено) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата);
	
КонецФункции

// Помещает двоичные данные дополнительного отчета или обработки во временное хранилище.
Функция ПоместитьВХранилище(Ссылка, ИдентификаторФормы) Экспорт
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ ДополнительныеОтчетыИОбработки.ВозможнаВыгрузкаОбработкиВФайл(Ссылка) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выгрузки файлов дополнительных отчетов и обработок'");
	КонецЕсли;
	
	ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
	
	Возврат ПоместитьВоВременноеХранилище(ХранилищеОбработки.Получить(), ИдентификаторФормы);
КонецФункции

Функция ОписаниеКомандыОбработки(ИмяЭлемента, АдресТаблицыКомандВоВременномХранилище) Экспорт
	Возврат ДополнительныеОтчетыИОбработки.ОписаниеКомандыОбработки(ИмяЭлемента, АдресТаблицыКомандВоВременномХранилище);
КонецФункции

// Запускает длительную операцию.
Функция ЗапуститьДлительнуюОперацию(Знач УникальныйИдентификатор, Знач ПараметрыКоманды) Экспорт
	ИмяМетода = "ДополнительныеОтчетыИОбработки.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	НастройкиЗапуска.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнение дополнительного отчета или обработки ""%1"", имя команды ""%2""'"),
		Строка(ПараметрыКоманды.ДополнительнаяОбработкаСсылка),
		ПараметрыКоманды.ИдентификаторКоманды);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыКоманды, НастройкиЗапуска);
КонецФункции

#КонецОбласти
