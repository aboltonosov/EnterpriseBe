﻿#Область СлужебныеПроцедурыИФункции

// Процедура заполняет справочник показателей т.н. псевдопредопределенными элементами, 
// идентифицируемыми из кода
//
Процедура СоздатьВидыИспользованияРабочегоВремениПоНастройкам(НастройкиРасчетаЗарплаты) Экспорт
	
	// Установка реквизитов предопределенных элементов.
	
	ОписаниеВидаВремени = УчетРабочегоВремени.СоздатьОписаниеВидаВремени();
	ОписаниеВидаВремени.ИмяПредопределенныхДанных = "Явка";
	// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
	ОписаниеВидаВремени.Наименование = "Явка";
	ОписаниеВидаВремени.БуквенныйКод = "Я";
	ОписаниеВидаВремени.БуквенныйКодБюджетный = "Я";
	ОписаниеВидаВремени.БуквенныйКодБюджетный2009 = "Я";
	ОписаниеВидаВремени.ЦифровойКод = "01";
	ОписаниеВидаВремени.ПолноеНаименование = НСтр("ru = 'Продолжительность работы в дневное время'");
	ОписаниеВидаВремени.РабочееВремя = Истина;
	ОписаниеВидаВремени.Целосменное = Ложь;
	
	УчетРабочегоВремени.НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени); 
	
	ОписаниеВидаВремени = УчетРабочегоВремени.СоздатьОписаниеВидаВремени();
	ОписаниеВидаВремени.ИмяПредопределенныхДанных = "ОсновнойОтпуск";
	// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
	ОписаниеВидаВремени.Наименование = "Отпуск";
	ОписаниеВидаВремени.БуквенныйКод = "ОТ";
	ОписаниеВидаВремени.БуквенныйКодБюджетный = "О";
	ОписаниеВидаВремени.БуквенныйКодБюджетный2009 = "О";
	ОписаниеВидаВремени.ЦифровойКод = "09";
	ОписаниеВидаВремени.ПолноеНаименование = НСтр("ru = 'Отпуск'");
	ОписаниеВидаВремени.РабочееВремя = Ложь;
	ОписаниеВидаВремени.Целосменное = Истина;
	
	УчетРабочегоВремени.НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени);
	
	ОписаниеВидаВремени = УчетРабочегоВремени.СоздатьОписаниеВидаВремени();
	ОписаниеВидаВремени.ИмяПредопределенныхДанных = "ОтпускПоБеременностиИРодам";
	// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
	ОписаниеВидаВремени.Наименование = "Отпуск по беременности и родам";
	ОписаниеВидаВремени.БуквенныйКод = "Р";
	ОписаниеВидаВремени.БуквенныйКодБюджетный = "Б";
	ОписаниеВидаВремени.БуквенныйКодБюджетный2009 = "Р";
	ОписаниеВидаВремени.ЦифровойКод = "14";
	ОписаниеВидаВремени.ПолноеНаименование = НСтр("ru = 'Отпуск по беременности и родам'");
	ОписаниеВидаВремени.РабочееВремя = Ложь;
	ОписаниеВидаВремени.Целосменное = Истина;
	
	УчетРабочегоВремени.НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени);
	
	ОписаниеВидаВремени = УчетРабочегоВремени.СоздатьОписаниеВидаВремени();
	ОписаниеВидаВремени.ИмяПредопределенныхДанных = "Болезнь";
	// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
	ОписаниеВидаВремени.Наименование = "Больничный";
	ОписаниеВидаВремени.БуквенныйКод = "Б";
	ОписаниеВидаВремени.БуквенныйКодБюджетный = "Б";
	ОписаниеВидаВремени.БуквенныйКодБюджетный2009 = "Б";
	ОписаниеВидаВремени.ЦифровойКод = "19";
	ОписаниеВидаВремени.ПолноеНаименование = НСтр("ru = 'Временная нетрудоспособность с назначением пособия согласно законодательству'");
	ОписаниеВидаВремени.РабочееВремя = Ложь;
	ОписаниеВидаВремени.Целосменное = Истина;
	
	УчетРабочегоВремени.НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени);
	
	ОписаниеВидаВремени = УчетРабочегоВремени.СоздатьОписаниеВидаВремени();
	ОписаниеВидаВремени.ИмяПредопределенныхДанных = "ВыходныеДни";
	// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
	ОписаниеВидаВремени.Наименование = "Выходные дни";
	ОписаниеВидаВремени.БуквенныйКод = "В";
	ОписаниеВидаВремени.БуквенныйКодБюджетный = "В";
	ОписаниеВидаВремени.БуквенныйКодБюджетный2009 = "В";
	ОписаниеВидаВремени.ЦифровойКод = "26";
	ОписаниеВидаВремени.ПолноеНаименование = НСтр("ru = 'Выходные дни (еженедельный отпуск) и  нерабочие праздничные дни'");
	ОписаниеВидаВремени.РабочееВремя = Ложь;
	ОписаниеВидаВремени.Целосменное = Истина;
	
	УчетРабочегоВремени.НовыйВидИспользованияРабочегоВремени(ОписаниеВидаВремени);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Процедура ОтключитьНеИспользуемыеВидыИспользованияРабочегоВремени() Экспорт
	
	ОсталяемыеВидыИспользованияРабочегоВремени = Новый Массив;
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка");
	Если ВидВремени <> Неопределено Тогда
		ОсталяемыеВидыИспользованияРабочегоВремени.Добавить(ВидВремени);
	КонецЕсли;
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ОсновнойОтпуск");
	Если ВидВремени <> Неопределено Тогда
		ОсталяемыеВидыИспользованияРабочегоВремени.Добавить(ВидВремени);
	КонецЕсли;
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ОтпускПоБеременностиИРодам");
	Если ВидВремени <> Неопределено Тогда
		ОсталяемыеВидыИспользованияРабочегоВремени.Добавить(ВидВремени);
	КонецЕсли;
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Болезнь");
	Если ВидВремени <> Неопределено Тогда
		ОсталяемыеВидыИспользованияРабочегоВремени.Добавить(ВидВремени);
	КонецЕсли;
	
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ВыходныеДни");
	Если ВидВремени <> Неопределено Тогда
		ОсталяемыеВидыИспользованияРабочегоВремени.Добавить(ВидВремени);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсталяемыеВидыИспользованияРабочегоВремени", ОсталяемыеВидыИспользованияРабочегоВремени);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыИспользованияРабочегоВремени.ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
		|ГДЕ
		|	НЕ ВидыИспользованияРабочегоВремени.Ссылка В (&ОсталяемыеВидыИспользованияРабочегоВремени)
		|	И ВидыИспользованияРабочегоВремени.ИмяПредопределенныхДанных <> """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		УчетРабочегоВремени.ОтключитьИспользованиеПредопределенногоЭлемента(Выборка.ИмяПредопределенныхДанных);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
