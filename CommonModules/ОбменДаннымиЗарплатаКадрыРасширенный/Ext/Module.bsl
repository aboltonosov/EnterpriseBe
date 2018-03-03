﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Синхронизация данных".
// Серверные процедуры, обслуживающие правила регистрации объектов.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Определяет список планов обмена, которые используют функционал подсистемы обмена данными.
//
// Параметры:
// ПланыОбменаПодсистемы. Тип: Массив.
// Массив планов обмена конфигурации, которые используют функционал подсистемы обмена данными.
// Элементами массива являются объекты метаданных планов обмена.
//
// Пример тела процедуры:
//
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменБезИспользованияПравилКонвертации);
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменСБиблиотекойСтандартныхПодсистем);
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.РаспределеннаяИнформационнаяБаза);
//
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт
	
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "АвтономнаяРабота");
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "ОбменВРаспределеннойИнформационнойБазе");
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "ОбменЗарплата3Бухгалтерия3");
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "ОбменЗГУБГУ1");
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "ОбменЗГУБГУ2");
	ДобавитьПланОбмена(ПланыОбменаПодсистемы, "СинхронизацияДанныхЧерезУниверсальныйФормат");
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений сотрудников для получения списка узлов-получателей по организациям,
// в которых установлены трудовые отношения по этим сотрудникам.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена.
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана
//      обмена, для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат
//      недопустимые типы данных для платформенного механизма кэширования, то флаг следует сбросить. Значение по
//      умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта.
//  Сотрудники - Ссылка или массив ссылок сотрудников, по которым нужно получить список узлов-получателей.
//  ДатаСведений - дата на которую необходимо получить данные сотрудников, применимо к данным, носящим периодический
//                 характер.
//      Если дату не указывать, будут получены самые последние данные.
Процедура ОграничитьРегистрациюОбъектаОтборомПоОрганизациямСотрудников(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, Сотрудники, ДатаСведений = '00010101') Экспорт
	
	ПараметрыЗапроса.Вставить("Сотрудники",		Сотрудники);
	ПараметрыЗапроса.Вставить("ДатаСведений",	ДатаСведений);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КадроваяИсторияСотрудников.Организация
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&СвойствоОбъекта_ДатаСведений, ) КАК КадроваяИсторияСотрудников
	|ГДЕ
	|	КадроваяИсторияСотрудников.Сотрудник В(&СвойствоОбъекта_Сотрудники)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Организация
	|ИЗ
	|	РегистрСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера КАК ПериодыДействияДоговоровГражданскоПравовогоХарактера
	|ГДЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Сотрудник В(&СвойствоОбъекта_Сотрудники)
	|	И ПериодыДействияДоговоровГражданскоПравовогоХарактера.ДатаНачала >= &СвойствоОбъекта_ДатаСведений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОрганизации.Организация В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Организации.Организация
	|			ИЗ
	|				ВТОрганизации КАК Организации)
	|	И ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбменаОрганизации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1.Организации'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбменаЭтотУзел",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='&%1ЭтотУзел'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоРеквизитуФлагу", "[УсловиеОтбораПоРеквизитуФлагу]");
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений физических лиц для получения списка узлов-получателей по организациям,
// в которых установлены трудовые отношения по этим физическим лицам.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена.
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана
//      обмена, для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат
//      недопустимые типы данных для платформенного механизма кэширования, то флаг следует сбросить. Значение по
//      умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта.
//  ФизическиеЛица - Ссылка или массив ссылок физических лиц, по которым нужно получить список узлов-получателей.
//  ДополнительныеПараметрыПолученияСотрудников - Структура параметров, которые будут использоваться для получения
//                                                списка сотрудников физического лица.
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоФизическимЛицамСТрудовымиОтношениями(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ФизическиеЛица, ТолькоСТрудовымиОтношениями = Ложь) Экспорт
	
	ПараметрыЗапроса.Вставить("ФизическиеЛица",					ФизическиеЛица);
	ПараметрыЗапроса.Вставить("ТолькоСТрудовымиОтношениями",	ТолькоСТрудовымиОтношениями);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КадроваяИсторияСотрудников.Организация
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
	|ГДЕ
	|	КадроваяИсторияСотрудников.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Организация
	|ИЗ
	|	РегистрСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера КАК ПериодыДействияДоговоровГражданскоПравовогоХарактера
	|ГДЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)
	|	И Организации.ИндивидуальныйПредприниматель В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиФизическихЛиц.Организация
	|ИЗ
	|	РегистрСведений.РолиФизическихЛиц КАК РолиФизическихЛиц
	|ГДЕ
	|	РолиФизическихЛиц.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОрганизации.Организация В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Организации.Организация
	|			ИЗ
	|				ВТОрганизации КАК Организации)
	|	И ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И НЕ &СвойствоОбъекта_ТолькоСТрудовымиОтношениями
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &СвойствоОбъекта_ТолькоСТрудовымиОтношениями
	|	И 1 В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				1
	|			ИЗ
	|				ВТОрганизации)
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбменаОрганизации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1.Организации'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбменаЭтотУзел",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='&%1ЭтотУзел'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоРеквизитуФлагу", "[УсловиеОтбораПоРеквизитуФлагу]");
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений физических лиц или контрагентов для получения списка узлов-получателей
// по организациям, в которых установлены трудовые отношения по этим физическим лицам.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена.
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана
//      обмена, для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат
//      недопустимые типы данных для платформенного механизма кэширования, то флаг следует сбросить. Значение по
//      умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта.
//  ФизическиеЛица - Ссылка или массив ссылок физических лиц или контрагентов, по которым нужно получить список
//                   узлов-получателей.
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоФизическимЛицамКонтрагентам(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, ФизическиеЛица) Экспорт
	
	ПараметрыЗапроса.Вставить("ФизическиеЛица", ФизическиеЛица);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КадроваяИсторияСотрудников.Организация
	|ПОМЕСТИТЬ ВТОрганизации
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
	|ГДЕ
	|	КадроваяИсторияСотрудников.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Организация
	|ИЗ
	|	РегистрСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера КАК ПериодыДействияДоговоровГражданскоПравовогоХарактера
	|ГДЕ
	|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)
	|	И Организации.ИндивидуальныйПредприниматель В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиФизическихЛиц.Организация
	|ИЗ
	|	РегистрСведений.РолиФизическихЛиц КАК РолиФизическихЛиц
	|ГДЕ
	|	РолиФизическихЛиц.ФизическоеЛицо В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РегистрацииВНалоговомОргане.Владелец
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.Представитель В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПолучателиУдержаний.Организация
	|ИЗ
	|	РегистрСведений.ПолучателиУдержаний КАК ПолучателиУдержаний
	|ГДЕ
	|	ПолучателиУдержаний.Контрагент В(&СвойствоОбъекта_ФизическиеЛица)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УсловияУдержанияПоИсполнительномуДокументу.Организация
	|ИЗ
	|	РегистрСведений.УсловияУдержанияПоИсполнительномуДокументу КАК УсловияУдержанияПоИсполнительномуДокументу
	|ГДЕ
	|	УсловияУдержанияПоИсполнительномуДокументу.ПлатежныйАгент В(&СвойствоОбъекта_ФизическиеЛица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОрганизации.Организация В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Организации.Организация
	|			ИЗ
	|				ВТОрганизации КАК Организации)
	|	И ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И 1 В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				1
	|			ИЗ
	|				ВТОрганизации)
	|	И &УсловиеОтбораПоРеквизитуФлагу
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбменаОрганизации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1.Организации'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяПланаОбменаЭтотУзел",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='&%1ЭтотУзел'"), ИмяПланаОбмена));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоРеквизитуФлагу", "[УсловиеОтбораПоРеквизитуФлагу]");
	
КонецПроцедуры

// Заменяет текст запроса регистрации изменений объектов, имеющих реквизит с типом "СправочникСсылка.СтруктураПредприятия",
// для получения списка узлов-получателей по организациям, если структура предприятия соответствует структуре юридических лиц.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена.
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана
//      обмена, для которого создано это правило.
//  ТекстЗапроса - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса - Структура - содержит значения свойств текущей версии объекта,
//      которые используются в качестве параметров в запросе для определения узлов-получателей.
//  ИспользоватьКэш - Булево - параметр определяет включение платформенного механизма повторно используемых значений
//      при определении узлов-получателей. Если передаваемые запросу значения в структуре ПараметрыЗапроса содержат
//      недопустимые типы данных для платформенного механизма кэширования, то флаг следует сбросить. Значение по
//      умолчанию - Истина.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта.
//  СтруктураПредприятия - Ссылка или массив ссылок на структуру предприятия, по которым нужно получить список узлов-получателей.
//
Процедура ОграничитьРегистрациюОбъектаОтборомПоОрганизациямСтруктурыПредприятия(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, СтруктураПредприятия) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ОграничитьРегистрациюОбъектаОтборомПоОрганизациямСтруктурыПредприятия(
			ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка, СтруктураПредприятия);
	КонецЕсли;
	
КонецПроцедуры

// Определяет максимальный и минимальный период записей набора записей.
//
// Параметры:
//  НаборЗаписей - Регистрируемый набор записей.
//  НачалоПериода - Дата - Будет помещена дата начала периода, за который требуется получить рабочие места сотрудников.
//  КонецПериода - Дата - Будет помещена дата окончания периода, за который требуется получить рабочие места
//                        сотрудников.
//  ИмяКолонкиСотрудника - Строка - Наименование колонки сотрудника в наборе записей регистра сведений.
//  ИмяКолонкиПериод - Строка - Наименование колонки периода в наборе записей регистра сведений.
//
Процедура ОпределитьПериодДляНабораЗаписей(МенеджерВременныхТаблиц, НаборЗаписей, ОбъектМетаданных, НачалоПериода, КонецПериода, ИмяКолонкиСотрудника = "Сотрудник", ИмяКолонкиПериод = "Период")
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НаборЗаписей", НаборЗаписей.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаборЗаписей.Период КАК Период,
	|	НаборЗаписей.Сотрудник КАК Сотрудник,";
	Для каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		Если Измерение.ОсновнойОтбор И Измерение.Имя <> ИмяКолонкиСотрудника И Измерение.Имя <> ИмяКолонкиПериод Тогда
			Запрос.Текст = Запрос.Текст + "
			|	НаборЗаписей." + Измерение.Имя + ",";
		КонецЕсли;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст);
	
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТНаборЗаписей
	|ИЗ
	|	&НаборЗаписей КАК НаборЗаписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛицаПоГПХ
	|ИЗ
	|	ВТНаборЗаписей КАК НаборЗаписей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО НаборЗаписей.Сотрудник = Сотрудники.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(НаборЗаписей.Период) КАК НачалоПериода,
	|	МАКСИМУМ(НаборЗаписей.Период) КАК КонецПериода
	|ИЗ
	|	ВТНаборЗаписей КАК НаборЗаписей";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "НаборЗаписей.Период КАК Период", "НаборЗаписей." + ИмяКолонкиПериод + " КАК Период");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "НаборЗаписей.Сотрудник КАК Сотрудник", "НаборЗаписей." + ИмяКолонкиСотрудника + " КАК Сотрудник");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	НачалоПериода = Выборка.НачалоПериода;
	КонецПериода = Выборка.КонецПериода;
	
КонецПроцедуры

// Определяет организации, в которых работали сотрудники в течение месяца.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена.
//  НаборЗаписей - Регистрируемый набор записей.
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана
//      обмена, для которого создано это правило.
//  ОбъектМетаданных - объект метаданных, соответствующий параметру Объект.
//  ПРО - СтрокаТаблицыЗначений - ссылка на правило регистрации объектов.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта.
//  ИмяКолонкиСотрудника - Строка - Наименование колонки сотрудника в наборе записей регистра сведений.
//  ИмяКолонкиПериод - Строка - Наименование колонки периода в наборе записей регистра сведений.
//
Процедура ОпределитьМассивыУзловДляНабораЗаписейПоСотрудникамИПериоду(ИмяПланаОбмена, НаборЗаписей, Отказ, ОбъектМетаданных, ПРО, Выгрузка, ИмяКолонкиСотрудника = "Сотрудник", ИмяКолонкиПериод = "Период") Экспорт
	
	Если Выгрузка Или НаборЗаписей.Количество() = 0 Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("Выгрузка", Выгрузка);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	НачалоПериода = Неопределено;
	КонецПериода = Неопределено;
	ОпределитьПериодДляНабораЗаписей(Запрос.МенеджерВременныхТаблиц, НаборЗаписей, ОбъектМетаданных, НачалоПериода, КонецПериода, ИмяКолонкиСотрудника, ИмяКолонкиПериод);
	
	// Дополнение организаций:
	//	-) теми где сотрудник работает по договору (без приема на работу)
	ПараметрыВТДоговорники = КадровыйУчетРасширенный.ПараметрыДляСоздатьВТДоговорыГПХФизическихЛицПоВременнойТаблице(
								"ВТФизическиеЛицаПоГПХ",
								,
								НачалоМесяца(НачалоПериода),
								КонецМесяца(КонецПериода));
	
	ПараметрыПолученияРабочихМест = КадровыйУчет.ПараметрыДляЗапросВТРабочиеМестаСотрудниковПоСпискуСотрудников();
	ПараметрыПолученияРабочихМест.НачалоПериода		= НачалоМесяца(НачалоПериода);
	ПараметрыПолученияРабочихМест.ОкончаниеПериода  = КонецМесяца(КонецПериода);
	ПараметрыПолученияРабочихМест.СписокСотрудников = НаборЗаписей.ВыгрузитьКолонку(ИмяКолонкиСотрудника);
		
	КадровыйУчет.СоздатьВТРабочиеМестаСотрудников(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияРабочихМест);
	КадровыйУчетРасширенный.СоздатьВТДоговорыГПХФизическихЛицПоВременнойТаблице(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыВТДоговорники);
	
	Запрос.УстановитьПараметр("ИмяПланаОбменаЭтотУзел", ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяПланаОбмена));
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорыГПХФизическихЛиц.Сотрудник КАК Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК УзелПланаОбмена
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДоговорыГПХФизическихЛиц КАК ДоговорыГПХФизическихЛиц
	|		ПО (ПланОбменаОрганизации.Организация = ДоговорыГПХФизическихЛиц.Организация)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РабочиеМестаСотрудников.Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРабочиеМестаСотрудников КАК РабочиеМестаСотрудников
	|		ПО (ПланОбменаОрганизации.Организация = РабочиеМестаСотрудников.Организация)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорыГПХФизическихЛиц.Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДоговорыГПХФизическихЛиц КАК ДоговорыГПХФизическихЛиц
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И ДоговорыГПХФизическихЛиц.Сотрудник ЕСТЬ НЕ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоговорыГПХФизическихЛиц.Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РабочиеМестаСотрудников.Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|ИЗ
	|	#ПланОбмена КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ПланОбменаОрганизации КАК ПланОбменаОрганизации
	|		ПО (ПланОбменаОрганизации.Ссылка = ПланОбменаОсновнаяТаблица.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМестаСотрудников КАК РабочиеМестаСотрудников
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка <> &ИмяПланаОбменаЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И РабочиеМестаСотрудников.Сотрудник ЕСТЬ НЕ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	РабочиеМестаСотрудников.Сотрудник,
	|	ПланОбменаОсновнаяТаблица.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ПланОбменаОрганизации.Организация) = 0";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ПланОбменаОрганизации",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1.Организации'"), ИмяПланаОбмена));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ПланОбмена",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='ПланОбмена.%1'"), ИмяПланаОбмена));
	
	МассивыУзлов = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивУзлов = МассивыУзлов.Получить(Выборка.Сотрудник);
		Если МассивУзлов = Неопределено Тогда
			МассивыУзлов.Вставить(Выборка.Сотрудник, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка.УзелПланаОбмена));
		Иначе
			Если МассивУзлов.Найти(Выборка.УзелПланаОбмена) = Неопределено Тогда
				МассивУзлов.Добавить(Выборка.УзелПланаОбмена);
			КонецЕсли;
			МассивыУзлов.Вставить(Выборка.Сотрудник, МассивУзлов);
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.ДополнительныеСвойства.Вставить("МассивыУзлов", МассивыУзлов);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОбъектМетаданных", ОбъектМетаданных);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ИмяКолонкиСотрудника", ИмяКолонкиСотрудника);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ИмяКолонкиПериод", ИмяКолонкиПериод);
	
КонецПроцедуры

// Процедура-обработчик события "ПриЗаписи" независимых регистров сведений для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации.
//  Источник       - НаборЗаписейРегистра - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура МеханизмРегистрацииОбъектовПриЗаписиНезависимогоРегистраСведений(ИмяПланаОбмена, Источник, Отказ, Замещение) Экспорт
	
	Если НЕ ОбменДаннымиВызовСервера.ОбменДаннымиВключен(ИмяПланаОбмена, Источник.ОбменДанными.Отправитель)
		Или Источник.Количество() = 0
		Или (Не Источник.ДополнительныеСвойства.Свойство("ОбъектМетаданных"))
		Или (Источник.ДополнительныеСвойства.Свойство("Выгрузка") И Источник.ДополнительныеСвойства.Выгрузка) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектМетаданных = Источник.ДополнительныеСвойства.ОбъектМетаданных;
	ИмяКолонкиСотрудника = Источник.ДополнительныеСвойства.ИмяКолонкиСотрудника;
	ИмяКолонкиПериод = Источник.ДополнительныеСвойства.ИмяКолонкиПериод;
	МассивыУзлов = Источник.ДополнительныеСвойства.МассивыУзлов;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаборЗаписей", Источник.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ *
	|ПОМЕСТИТЬ ВТНаборЗаписей
	|	ИЗ &НаборЗаписей КАК НаборЗаписей
	|;
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ";
	Для каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		Если Измерение.ОсновнойОтбор Тогда
			Запрос.Текст = Запрос.Текст + "
			|	НаборЗаписей." + Измерение.Имя  + ",";
		КонецЕсли;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст);
	Запрос.Текст = Запрос.Текст + "
	|ИЗ ВТНаборЗаписей КАК НаборЗаписей";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		КлючИзменений = РегистрыСведений[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
		Для каждого Измерение Из ОбъектМетаданных.Измерения Цикл
			Если Измерение.ОсновнойОтбор Тогда
				КлючИзменений.Отбор[Измерение.Имя].Значение = Выборка[Измерение.Имя];
				КлючИзменений.Отбор[Измерение.Имя].Использование = Истина;
			КонецЕсли;
		КонецЦикла;
		МассивУзлов = МассивыУзлов.Получить(Выборка[ИмяКолонкиСотрудника]);
		Если МассивУзлов <> Неопределено Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, КлючИзменений);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//  производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
Процедура ОбработкаРегистрацииНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		Модуль.ОбработкаРегистрацииНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗГУБГУ1") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменЗГУБГУ1");
		Модуль.ОбработкаРегистрацииНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗГУБГУ2") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменЗГУБГУ2");
		Модуль.ОбработкаРегистрацииНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
КонецПроцедуры

// Объединяет массивы, возвращая результат объединения
// Возвращаемое значение:
//  Массив - объединенный массив значений
Функция ОбъединитьМассивы(Массив1, Массив2) Экспорт
	
	ОбъединенныйМассив = Новый Массив;
	
	Для Каждого ЭлементМассива Из Массив1 Цикл
	
		Если ОбъединенныйМассив.Найти(ЭлементМассива) = Неопределено Тогда
			ОбъединенныйМассив.Добавить(ЭлементМассива);
		КонецЕсли; 
	
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из Массив2 Цикл
	
		Если ОбъединенныйМассив.Найти(ЭлементМассива) = Неопределено Тогда
			ОбъединенныйМассив.Добавить(ЭлементМассива);
		КонецЕсли; 
	
	КонецЦикла;
	
	Возврат ОбъединенныйМассив;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПланОбмена(ПланыОбменаПодсистемы, ИмяПланаОбмена)
	
	Если ОбменДаннымиВнешнееСоединение.ПланОбменаСуществует(ИмяПланаОбмена) Тогда
		ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена[ИмяПланаОбмена]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти