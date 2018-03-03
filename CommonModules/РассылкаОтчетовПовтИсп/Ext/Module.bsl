﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (сервер, результат кэшируется).
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает список значений перечисления "ФорматыСохраненияОтчетов".
//
// Возвращаемое значение: 
//   СписокФорматов - СписокЗначений - Список форматов, с пометками на системных форматах по умолчанию.
//       * Значение      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - Ссылка на описываемый формат.
//       * Представление - Строка - Пользовательское представление описываемого формата.
//       * Пометка       - Булево - Признак использования как формата по умолчанию.
//       * Картинка      - Картинка - Картинка формата.
//
Функция СписокФорматов() Экспорт
	СписокФорматов = Новый СписокЗначений;
	
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "HTML4", БиблиотекаКартинок.ФорматHTML, Истина);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "PDF"  , БиблиотекаКартинок.ФорматPDF);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "XLSX" , БиблиотекаКартинок.ФорматExcel2007);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "XLS"  , БиблиотекаКартинок.ФорматExcel);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "ODS"  , БиблиотекаКартинок.ФорматOpenOfficeCalc);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "MXL"  , БиблиотекаКартинок.ФорматMXL);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "DOCX" , БиблиотекаКартинок.ФорматWord2007);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "TXT"    , БиблиотекаКартинок.ФорматTXT);
	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "ANSITXT", БиблиотекаКартинок.ФорматTXT);
	
	РассылкаОтчетовПереопределяемый.ПереопределитьПараметрыФорматов(СписокФорматов);
	
	// Оставшиеся форматы
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Форматы.Ссылка
	|ИЗ
	|	Перечисление.ФорматыСохраненияОтчетов КАК Форматы
	|ГДЕ
	|	(НЕ Форматы.Ссылка В (&МассивФорматов))";
	Запрос.УстановитьПараметр("МассивФорматов", СписокФорматов.ВыгрузитьЗначения());
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокФорматов;
КонецФункции

// Таблица типов получателей в разрезах хранения и пользовательского представления этих типов.
//
// Возвращаемое значение: 
//   ТаблицаТипов - ТаблицаЗначений - Таблица типов получателей.
//       * ИОМД            - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Ссылка, которая хранится в базе данных.
//       * ТипПолучателей  - ОписаниеТипов - Тип, которым ограничиваются значения списков получателей и исключенных.
//       * Представление   - Строка - Представление типа для пользователей.
//       * ОсновнойВидКИ   - СправочникСсылка.ВидыКонтактнойИнформации - Вид контактной информации: e-mail, по
//                                                                       умолчанию.
//       * ГруппаКИ        - СправочникСсылка.ВидыКонтактнойИнформации - Группа вида контактной информации.
//       * ПутьФормыВыбора - Строка - Путь к форме выбора.
//
Функция ТаблицаТиповПолучателей() Экспорт
	ТаблицаТипов = Новый ТаблицаЗначений;
	ТаблицаТипов.Колонки.Добавить("ИОМД", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ТаблицаТипов.Колонки.Добавить("ТипПолучателей", Новый ОписаниеТипов("ОписаниеТипов"));
	ТаблицаТипов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ТаблицаТипов.Колонки.Добавить("ОсновнойВидКИ", Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	ТаблицаТипов.Колонки.Добавить("ГруппаКИ", Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	ТаблицаТипов.Колонки.Добавить("ПутьФормыВыбора", Новый ОписаниеТипов("Строка"));
	ТаблицаТипов.Колонки.Добавить("ОсновнойТип", Новый ОписаниеТипов("ОписаниеТипов"));
	
	ТаблицаТипов.Индексы.Добавить("ИОМД");
	ТаблицаТипов.Индексы.Добавить("ТипПолучателей");
	
	ДоступныеТипы = Метаданные.Справочники.РассылкиОтчетов.ТабличныеЧасти.Получатели.Реквизиты.Получатель.Тип.Типы();
	
	// Параметры справочников "Пользователи" + "Группы пользователей".
	НастройкиТипа = Новый Структура;
	НастройкиТипа.Вставить("ОсновнойТип",       Тип("СправочникСсылка.Пользователи"));
	НастройкиТипа.Вставить("ДополнительныйТип", Тип("СправочникСсылка.ГруппыПользователей"));
	РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы, НастройкиТипа);
	
	// Механизм расширения
	РассылкаОтчетовПереопределяемый.ПереопределитьТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы);
	
	// Параметры остальных справочников.
	ПустойМассив = Новый Массив;
	Для Каждого НеиспользованныйТип Из ДоступныеТипы Цикл
		РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей(ТаблицаТипов, ПустойМассив, Новый Структура("ОсновнойТип", НеиспользованныйТип));
	КонецЦикла;
	
	Возврат ТаблицаТипов;
КонецФункции

// Получает пустое значение для поиска по таблице "Отчеты" или "ФорматыОтчетов" справочника "РассылкиОтчетов".
Функция ПустоеЗначениеОтчета() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Возврат Метаданные.Справочники.РассылкиОтчетов.ТабличныеЧасти.ФорматыОтчетов.Реквизиты.Отчет.Тип.ПривестиЗначение();
КонецФункции

// Получает заголовок системы, а если он не задан - синоним метаданных конфигурации.
Функция ИмяЭтойИнформационнойБазы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Константы.ЗаголовокСистемы.Получить();
	
	Если ПустаяСтрока(Результат) Тогда
		
		Результат = Метаданные.Синоним;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Исключаемые отчеты используются в качестве исключающего фильтра при выборе отчетов.
Функция ИсключаемыеОтчеты() Экспорт
	МассивМетаданных = Новый Массив;
	РассылкаОтчетовПереопределяемый.ОпределитьИсключаемыеОтчеты(МассивМетаданных);
	
	Результат = Новый Массив;
	Для Каждого ОтчетМетаданные Из МассивМетаданных Цикл
		Результат.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОтчетМетаданные));
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Проверяет права и формирует текст ошибки.
Функция ТекстОшибкиПроверкиПраваДобавления() Экспорт
	Если Не ПравоДоступа("Вывод", Метаданные) Тогда
		Возврат НСтр("ru = 'Нет прав на вывод информации.'");
	КонецЕсли;
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.РассылкиОтчетов) Тогда
		Возврат НСтр("ru = 'Нет прав на рассылки отчетов.'");
	КонецЕсли;
	Если Не РаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем() Тогда
		Возврат НСтр("ru = 'Нет прав на отправку писем или нет доступных учетных записей.'");
	КонецЕсли;
	Возврат "";
КонецФункции

#КонецОбласти
