﻿//++ НЕ УТКА

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка 
		ИЛИ НЕ ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства)
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиЗаказаМатериаловВПроизводство") Тогда

		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыКОтгрузкеПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Организация                КАК Организация,
	|	Таблица.Подразделение              КАК Подразделение,
	|	Таблица.Распоряжение               КАК Распоряжение,
	|	Таблица.КодСтрокиРаспоряжения      КАК КодСтрокиРаспоряжения,
	|	Таблица.ВариантОбеспечения         КАК ВариантОбеспечения,
	|	Таблица.ДатаПотребности            КАК ДатаПотребности,
	|	Таблица.КодСтроки                  КАК КодСтроки,
	|	Таблица.Отменено                   КАК Отменено,
	|	Таблица.ПроизводствоНаСтороне      КАК ПроизводствоНаСтороне,
	|	Таблица.Серия                      КАК Серия,
	|	Таблица.Склад                      КАК Склад,
	|	Таблица.Упаковка                   КАК Упаковка,
	|	Таблица.КоличествоУпаковок         КАК КоличествоУпаковокПередЗаписью
	|ПОМЕСТИТЬ ДвиженияЗаказыМатериаловСУчетомКорректировокПередЗаписью
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый";
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства)
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиЗаказаМатериаловВПроизводство")Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Организация                КАК Организация,
	|	ТаблицаИзменений.Подразделение              КАК Подразделение,
	|	ТаблицаИзменений.Распоряжение               КАК Распоряжение,
	|	ТаблицаИзменений.КодСтрокиРаспоряжения      КАК КодСтрокиРаспоряжения,
	|	ТаблицаИзменений.ВариантОбеспечения         КАК ВариантОбеспечения,
	|	ТаблицаИзменений.ДатаПотребности            КАК ДатаПотребности,
	|	ТаблицаИзменений.КодСтроки                  КАК КодСтроки,
	|	ТаблицаИзменений.Отменено                   КАК Отменено,
	|	ТаблицаИзменений.ПроизводствоНаСтороне      КАК ПроизводствоНаСтороне,
	|	ТаблицаИзменений.Серия                      КАК Серия,
	|	ТаблицаИзменений.Склад                      КАК Склад,
	|	ТаблицаИзменений.Упаковка                   КАК Упаковка,
	|	СУММА(ТаблицаИзменений.КоличествоУпаковокИзменение) КАК КоличествоУпаковокИзменение
	|ПОМЕСТИТЬ ЗаказыМатериаловСУчетомКорректировокИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Организация                КАК Организация,
	|		Таблица.Подразделение              КАК Подразделение,
	|		Таблица.Распоряжение               КАК Распоряжение,
	|		Таблица.КодСтрокиРаспоряжения      КАК КодСтрокиРаспоряжения,
	|		Таблица.ВариантОбеспечения         КАК ВариантОбеспечения,
	|		Таблица.ДатаПотребности            КАК ДатаПотребности,
	|		Таблица.КодСтроки                  КАК КодСтроки,
	|		Таблица.Отменено                   КАК Отменено,
	|		Таблица.ПроизводствоНаСтороне      КАК ПроизводствоНаСтороне,
	|		Таблица.Серия                      КАК Серия,
	|		Таблица.Склад                      КАК Склад,
	|		Таблица.Упаковка                   КАК Упаковка,
	|		Таблица.КоличествоУпаковокПередЗаписью КАК КоличествоУпаковокИзменение
	|	ИЗ
	|		ДвиженияЗаказыМатериаловСУчетомКорректировокПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Организация                КАК Организация,
	|		Таблица.Подразделение              КАК Подразделение,
	|		Таблица.Распоряжение               КАК Распоряжение,
	|		Таблица.КодСтрокиРаспоряжения      КАК КодСтрокиРаспоряжения,
	|		Таблица.ВариантОбеспечения         КАК ВариантОбеспечения,
	|		Таблица.ДатаПотребности            КАК ДатаПотребности,
	|		Таблица.КодСтроки                  КАК КодСтроки,
	|		Таблица.Отменено                   КАК Отменено,
	|		Таблица.ПроизводствоНаСтороне      КАК ПроизводствоНаСтороне,
	|		Таблица.Серия                      КАК Серия,
	|		Таблица.Склад                      КАК Склад,
	|		Таблица.Упаковка                   КАК Упаковка,
	|		-Таблица.КоличествоУпаковок        КАК КоличествоУпаковокИзменение
	|	ИЗ
	|		РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.Распоряжение,
	|	ТаблицаИзменений.КодСтрокиРаспоряжения,
	|	ТаблицаИзменений.ВариантОбеспечения,
	|	ТаблицаИзменений.ДатаПотребности,
	|	ТаблицаИзменений.КодСтроки,
	|	ТаблицаИзменений.Отменено,
	|	ТаблицаИзменений.ПроизводствоНаСтороне,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.Упаковка
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КоличествоУпаковокИзменение) > 0
	|;
	|УНИЧТОЖИТЬ ДвиженияЗаказыМатериаловСУчетомКорректировокПередЗаписью
	|";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ЗаказыМатериаловСУчетомКорректировокИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыМатериаловСУчетомКорректировокИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли

//-- НЕ УТКА