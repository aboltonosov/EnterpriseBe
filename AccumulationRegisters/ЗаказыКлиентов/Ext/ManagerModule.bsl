﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|//////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Склад)          КАК Склад,
		|	МАКСИМУМ(РегистрЗаказы.Серия)          КАК Серия,
		|
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|				РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК Количество,
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|				РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоПриход,
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			И РегистрЗаказы.КОформлению < 0 И НЕ Расхождения.Ссылка ЕСТЬ NULL ТОГДА
		|				- РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоКорректировка
		|ИЗ
		|	ВтОтбор КАК Отбор
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыКлиентов КАК РегистрЗаказы
		|		ПО РегистрЗаказы.ЗаказКлиента = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаРеализации.Расхождения КАК Расхождения
		|		ПО Расхождения.Ссылка = РегистрЗаказы.Регистратор
		|		 И Расхождения.ЗаказКлиента = РегистрЗаказы.ЗаказКлиента
		|		 И Расхождения.КодСтроки = РегистрЗаказы.КодСтроки
		|		 И Расхождения.ВариантОтражения
		|			= ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокРеализаций.УменьшитьРеализациюУчестьПриИнвентаризации)
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");

	Возврат Таблица;

КонецФункции

//Возвращает текст запроса заказанного количества из заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказанного по заказам количества.
//
//Параметры:
//	ЕстьФильтр - Булево - Признак, определяющий необходимость предварительной фильтрации выборки по заказам,
//	                      передаваемым параметром "Заказы",
//	ПолучатьНесогласованные - Булево - Признак, определяющий, нужно ли учитывать заказы в статусе "Не согласован".
//
//Возвращаемое значение:
//	Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовКОбеспечению(ЕстьФильтр, ПолучатьНесогласованные) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Т.ЗаказКлиента          КАК Заказ,
		|	Т.КодСтроки             КАК КодСтроки,
		|	Т.ЗаказаноПриход - Т.КОформлениюПриход КАК Количество
		|ПОМЕСТИТЬ ВтРегистрЗаказыКлиентов
		|ИЗ
		|	РегистрНакопления.ЗаказыКлиентов.ОстаткиИОбороты(,,,,
		|		{Склад.* КАК Склад,
		|		ЗаказКлиента.* КАК Заказ}
		|		Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) И ЗаказКлиента В (&Заказы)) КАК Т
		|ГДЕ
		|	Т.ЗаказаноПриход - Т.КОформлениюПриход > 0";

	Если ПолучатьНесогласованные И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента) Тогда

		ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";

		ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Т.Ссылка       КАК Заказ,
			|	Т.КодСтроки    КАК КодСтроки,
			|	Т.Количество   КАК Количество
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК Т
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документ
			|		ПО Т.Ссылка = Документ.Ссылка
			|		И Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.НеСогласован)
			|		И Документ.Проведен
			|		И НЕ Т.Отменено
			|		И Т.Номенклатура.ТипНоменклатуры В(
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
			|		И Т.Ссылка В (&Заказы)
			|{ГДЕ
			|	Т.Склад.* КАК Склад, Т.Ссылка.* КАК Заказ}";

	КонецЕсли;

	Если ПолучатьНесогласованные И ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента) Тогда

		ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";

		ТекстЗапроса = ТекстЗапроса + "

			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Т.Ссылка       КАК Заказ,
			|	Т.КодСтроки    КАК КодСтроки,
			|	Т.Количество   КАК Количество
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК Т
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК Документ
			|		ПО Т.Ссылка = Документ.Ссылка
			|		И Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована)
			|		И Документ.Проведен
			|		И НЕ Т.Отменено
			|		И Т.Номенклатура.ТипНоменклатуры В(
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
			|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
			|		И Т.Ссылка В (&Заказы)
			|{ГДЕ
			|	Т.Ссылка.Склад.* КАК Склад, Т.Ссылка.* КАК Заказ}";

	КонецЕсли;

	Если Не ЕстьФильтр Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " И ЗаказКлиента В (&Заказы)", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Т.Ссылка В (&Заказы)", "");
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Заказ, КодСтроки
		|;
		|
		|////////////////////////////////////////////
		|";

	Возврат ТекстЗапроса;

КонецФункции

//Возвращает текст запроса заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Учитываются только товары и тара.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказов,
//содержащих указанную номенклатуру на указанном складе.
//
//Параметры:
//	ПолучатьНесогласованные - Булево - Признак, определяющий, нужно ли учитывать заказы в статусе "Не согласован".
//
//Возвращаемое значение:
//	Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры(ПолучатьНесогласованные) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Т.ЗаказКлиента КАК Заказ
		|ИЗ
		|	РегистрНакопления.ЗаказыКлиентов.ОстаткиИОбороты(,,,,
		|		Номенклатура.ТипНоменклатуры В(
		|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
		|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
		|			ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
		|		{Склад.* КАК Склад, Номенклатура.* КАК Номенклатура}) КАК Т
		|ГДЕ
		|	Т.ЗаказаноПриход - Т.КОформлениюПриход > 0";

	Если ПолучатьНесогласованные Тогда

		ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";

		ТекстЗапроса = ТекстЗапроса + "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Т.Ссылка       КАК Заказ
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК Т
			|ГДЕ
			|	Т.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.НеСогласован)
			|	И Т.Ссылка.Проведен
			|	И НЕ Т.Отменено
			|	И Т.ВариантОбеспечения <> ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
			|	И Т.Номенклатура.ТипНоменклатуры В(
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
			|{ГДЕ
			|	Т.Склад.* КАК Склад, Т.Номенклатура.* КАК Номенклатура}
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Т.Ссылка       КАК Заказ
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК Т
			|ГДЕ
			|	Т.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована)
			|	И Т.Ссылка.Проведен
			|	И НЕ Т.Отменено
			|	И Т.ВариантОбеспечения <> ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.НеТребуется)
			|	И Т.Номенклатура.ТипНоменклатуры В(
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара),
			|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
			|{ГДЕ
			|	Т.Ссылка.Склад.* КАК Склад, Т.Номенклатура.* КАК Номенклатура}";

	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

//++ НЕ УТ

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Текст запроса получает остаток по ресурсам КОформлению и Заказано
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Выражение			 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//   - Строка
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", Измерения = Неопределено, Ресурсы = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.Распоряжение          КАК Распоряжение,
	|	Набор.Номенклатура          КАК Номенклатура,
	|	Набор.Характеристика        КАК Характеристика,
	|	Набор.КодСтроки             КАК КодСтроки,
	|	Набор.Серия                 КАК Серия,
	|	Набор.Склад                 КАК Склад,
	|	СУММА(Набор.Заказано)       КАК Заказано,
	|	СУММА(Набор.КОформлению)    КАК КОформлению
	|//&ПОМЕСТИТЬ
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ЗаказКлиента          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Склад                 КАК Склад,
	|		Таблица.ЗаказаноОстаток       КАК Заказано,
	|		Таблица.КОформлениюОстаток    КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыКлиентов.Остатки(, 
	|//&ОтборПоИзмерениямРегистр
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ЗаказКлиента          КАК Распоряжение,
	|		Таблица.Номенклатура          КАК Номенклатура,
	|		Таблица.Характеристика        КАК Характеристика,
	|		Таблица.КодСтроки             КАК КодСтроки,
	|		Таблица.Серия                 КАК Серия,
	|		Таблица.Склад                 КАК Склад,
	|		Таблица.Заказано              КАК Заказано,
	|		Таблица.КОформлению           КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыКлиентов КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор = &Регистратор
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|//&ОтборПоИзмерениямСторно
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	Распоряжение,
	|	Номенклатура,
	|	Характеристика,
	|	КодСтроки,
	|	Серия,
	|	Склад
	|
	|//&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Набор.Распоряжение,
		|	Набор.КодСтроки";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Измерения) Тогда
		
		ТекстОтбораПоИзмерениям = "";
		
		Для Каждого КлючЗначение Из Измерения Цикл
			
			ТекстОтбораПоИзмерениям = 
				ТекстОтбораПоИзмерениям
				+ ?(ПустаяСтрока(ТекстОтбораПоИзмерениям), "", " И ")
				+ КлючЗначение.Ключ
				+ " В(&"
				+ КлючЗначение.Значение
				+ ")";
			
		КонецЦикла;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямРегистр", ТекстОтбораПоИзмерениям);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямСторно", Символы.ПС + "И " + ТекстОтбораПоИзмерениям);
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Ресурсы) Тогда
		
		Если СтрНайти(Ресурсы, "КОформлению") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "КОформлению", "СУММА(Набор.КОформлению)");
		КонецЕсли;
		Если СтрНайти(Ресурсы, "Заказано") <> 0 Тогда
			Ресурсы = СтрЗаменить(Ресурсы, "Заказано", "СУММА(Набор.Заказано)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Ресурсы);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
