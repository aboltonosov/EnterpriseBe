﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение классификатора.
Процедура ВыборочноеНачальноеЗаполнение()
	
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("Код");
	КлассификаторТаблица.Колонки.Добавить("Код_018_95");
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "016";
	НоваяСтрокаКлассификатора.Код_018_95 = "014";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Английский'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "171";
	НоваяСтрокаКлассификатора.Код_018_95 = "135";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Немецкий'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "258";
	НоваяСтрокаКлассификатора.Код_018_95 = "213";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Французский'");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЯзыкиНародовМира.Код,
		|	ЯзыкиНародовМира.Наименование,
		|	ЯзыкиНародовМира.Ссылка
		|ИЗ
		|	Справочник.ЯзыкиНародовМира КАК ЯзыкиНародовМира";
	
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		
		НайденныйЯзык = ТаблицаСуществующих.Найти(СтрокаКлассификатора.Наименование, "Наименование");
		Если НайденныйЯзык = Неопределено Или НайденныйЯзык.Код = СтрокаКлассификатора.Код_018_95 Тогда
			
			Если НайденныйЯзык <> Неопределено И НайденныйЯзык.Код = СтрокаКлассификатора.Код_018_95 Тогда
				СправочникОбъект = НайденныйЯзык.Ссылка.ПолучитьОбъект();
			Иначе
				
				СправочникОбъект = Справочники.ЯзыкиНародовМира.СоздатьЭлемент();
				ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаКлассификатора);
				
			КонецЕсли;
			
			СправочникОбъект.Код = СтрокаКлассификатора.Код;
			СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// При работе в модели сервиса классификатор изначально должен быть полностью заполнен.
//
Процедура ЗаполнитьСправочникПоКлассификатору(РазделениеВключено = Ложь) Экспорт
	
	// Полная загрузка классификатора нужна только в сервисе.
	Если РазделениеВключено Тогда
		ОбновитьКлассификатор(Истина);
	Иначе
		ВыборочноеНачальноеЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьКлассификатор(ДобавлятьНовые = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЯзыкиНародовМира.Ссылка,
		|	ЯзыкиНародовМира.Код,
		|	ЯзыкиНародовМира.Наименование
		|ИЗ
		|	Справочник.ЯзыкиНародовМира КАК ЯзыкиНародовМира";
		
	ТаблицаСправочника = Запрос.Выполнить().Выгрузить();
	ТаблицаСправочника.Колонки.Добавить("НаименованиеДляПоиска", Новый ОписаниеТипов("Строка"));
	
	Для каждого СтрокаТаблицыСправочника Из ТаблицаСправочника Цикл
		
		СтрокаТаблицыСправочника.НаименованиеДляПоиска = ВРег(СтрокаТаблицыСправочника.Наименование);
		СтрокаТаблицыСправочника.НаименованиеДляПоиска = СтрЗаменить(СтрокаТаблицыСправочника.НаименованиеДляПоиска, " ", "");
		СтрокаТаблицыСправочника.НаименованиеДляПоиска = СтрЗаменить(СтрокаТаблицыСправочника.НаименованиеДляПоиска, "-", "");
		
	КонецЦикла;
	
	ТекстовыйДокумент = Справочники.ЯзыкиНародовМира.ПолучитьМакет("КлассификаторЯзыковНародовМира");
	ТаблицаЯзыков = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Для каждого СтрокаТаблицыЯзыков Из ТаблицаЯзыков Цикл
		
		НаименованиеДляПоиска = ВРег(СтрокаТаблицыЯзыков.Name);
		НаименованиеДляПоиска = СтрЗаменить(НаименованиеДляПоиска, " ", "");
		НаименованиеДляПоиска = СтрЗаменить(НаименованиеДляПоиска, "-", "");
		
		СтрокаКлассификатора = Неопределено;
		Если ЗначениеЗаполнено(СтрокаТаблицыЯзыков.Code_018_95) Тогда
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Код", СтрокаТаблицыЯзыков.Code_018_95);
			СтруктураПоиска.Вставить("НаименованиеДляПоиска", НаименованиеДляПоиска);
			
			Если СтрДлина(СтруктураПоиска.Код) = 3 Тогда
				СтруктураПоиска.Код = СтруктураПоиска.Код + " ";
			КонецЕсли;
			
			СтрокиКлассификатора = ТаблицаСправочника.НайтиСтроки(СтруктураПоиска);
			
			Если СтрокиКлассификатора.Количество() > 0 Тогда
				СтрокаКлассификатора = СтрокиКлассификатора[0];
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаКлассификатора <> Неопределено Тогда
			
			Если СтрокаТаблицыЯзыков.Code_018_95 <> СтрокаТаблицыЯзыков.Code Тогда
				
				СправочникОбъект = СтрокаКлассификатора.Ссылка.ПолучитьОбъект();
				СправочникОбъект.Код = СокрЛП(СтрокаТаблицыЯзыков.Code);
				Если ПустаяСтрока(СправочникОбъект.Код) Тогда
					СправочникОбъект.ПометкаУдаления = Истина;
				КонецЕсли;
				
				СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
				СправочникОбъект.ОбменДанными.Загрузка = Истина;
				СправочникОбъект.Записать();
				
			КонецЕсли;
			
		ИначеЕсли ДобавлятьНовые И ЗначениеЗаполнено(СтрокаТаблицыЯзыков.Code) Тогда
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Код", СтрокаТаблицыЯзыков.Code);
			СтруктураПоиска.Вставить("НаименованиеДляПоиска", НаименованиеДляПоиска);
			
			Если СтрДлина(СтруктураПоиска.Код) = 3 Тогда
				СтруктураПоиска.Код = СтруктураПоиска.Код + " ";
			КонецЕсли;
			
			СтрокиКлассификатора = ТаблицаСправочника.НайтиСтроки(СтруктураПоиска);
			Если СтрокиКлассификатора.Количество() = 0 Тогда
				
				СправочникОбъект = Справочники.ЯзыкиНародовМира.СоздатьЭлемент();
				СправочникОбъект.Код = СокрЛП(СтрокаТаблицыЯзыков.Code);
				СправочникОбъект.Наименование = СокрЛП(СтрокаТаблицыЯзыков.Name);
				СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
				СправочникОбъект.ОбменДанными.Загрузка = Истина;
				СправочникОбъект.Записать();
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
// Используется для сопоставления элементов механизмом «Выгрузка/загрузка областей данных».
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьСведенияОЯзыкеКашмири() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", "107");
	Запрос.УстановитьПараметр("Наименование", "Кашмири");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЯзыкиНародовМира.Ссылка
		|ИЗ
		|	Справочник.ЯзыкиНародовМира КАК ЯзыкиНародовМира
		|ГДЕ
		|	ЯзыкиНародовМира.Код = &Код
		|	И ЯзыкиНародовМира.Наименование = &Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Код = "145";
		СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
		СправочникОбъект.ОбменДанными.Загрузка = Истина;
		СправочникОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли