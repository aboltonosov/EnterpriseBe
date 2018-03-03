﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	
	Если НЕ Отказ Тогда
		ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Документы.РегистрацияНаработокТМЦВЭксплуатации.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ОтразитьДвижения(
		ДополнительныеСвойства.ТаблицыДляДвижений.НаработкиТМЦВЭксплуатации,
		Движения.НаработкиТМЦВЭксплуатации,
		Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СформироватьЗаданиеПогашениеСтоимостиТМЦ();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СформироватьЗаданиеПогашениеСтоимостиТМЦ(Истина);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

#Область ЗаданияКЗакрытиюМесяца

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью()

	Если ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение 
		И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Ссылка.Дата, МЕСЯЦ) КАК Период,
	|	ТаблицаПередЗаписью.Ссылка.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ПартияТМЦВЭксплуатации,
	|	ТаблицаПередЗаписью.ТекущееЗначение,
	|	ТаблицаПередЗаписью.ПредельныйОбъем
	|ПОМЕСТИТЬ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПередЗаписью
	|ИЗ
	|	Документ.РегистрацияНаработокТМЦВЭксплуатации.Наработки КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СформироватьЗаданиеПогашениеСтоимостиТМЦ(ОтменаПроведения = Ложь)

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) КАК Дата,
	|	&Организация КАК Организация,
	|	&Проведен КАК Проведен,
	|	ТаблицаПослеЗаписи.ПартияТМЦВЭксплуатации,
	|	ТаблицаПослеЗаписи.ТекущееЗначение,
	|	ТаблицаПослеЗаписи.ПредельныйОбъем
	|ПОМЕСТИТЬ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПослеЗаписи
	|ИЗ
	|	&Наработки КАК ТаблицаПослеЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(Таблица.Период)  КАК Месяц,
	|	Таблица.Организация      КАК Организация,
	|	ЕСТЬNULL(ПакетыПогашенияСтоимостиТМЦ.НомерПакета, 0) КАК НомерПакета,
	|	&Ссылка                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПередЗаписью.Период КАК Период,
	|		ТаблицаПередЗаписью.Организация КАК Организация,
	|		ТаблицаПередЗаписью.ПартияТМЦВЭксплуатации КАК Партия
	|	ИЗ
	|		РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПослеЗаписи КАК ТаблицаПослеЗаписи
	|			ПО (ТаблицаПередЗаписью.ПартияТМЦВЭксплуатации = ТаблицаПослеЗаписи.ПартияТМЦВЭксплуатации)
	|				И (ТаблицаПередЗаписью.ТекущееЗначение = ТаблицаПослеЗаписи.ТекущееЗначение)
	|				И (ТаблицаПередЗаписью.ПредельныйОбъем = ТаблицаПослеЗаписи.ПредельныйОбъем)
	|				И (ТаблицаПередЗаписью.Организация = ТаблицаПослеЗаписи.Организация)
	|				И (НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ТаблицаПослеЗаписи.Дата, МЕСЯЦ))
	|				И (ТаблицаПослеЗаписи.Проведен = ИСТИНА)
	|	ГДЕ
	|		ТаблицаПослеЗаписи.ПартияТМЦВЭксплуатации ЕСТЬ NULL
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(ТаблицаПослеЗаписи.Дата, МЕСЯЦ),
	|		ТаблицаПослеЗаписи.Организация,
	|		ТаблицаПослеЗаписи.ПартияТМЦВЭксплуатации
	|	ИЗ
	|		РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПослеЗаписи КАК ТаблицаПослеЗаписи
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ПО (ТаблицаПередЗаписью.ПартияТМЦВЭксплуатации = ТаблицаПослеЗаписи.ПартияТМЦВЭксплуатации)
	|				И (ТаблицаПередЗаписью.ТекущееЗначение = ТаблицаПослеЗаписи.ТекущееЗначение)
	|				И (ТаблицаПередЗаписью.ПредельныйОбъем = ТаблицаПослеЗаписи.ПредельныйОбъем)
	|				И (ТаблицаПередЗаписью.Организация = ТаблицаПослеЗаписи.Организация)
	|				И (НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ТаблицаПослеЗаписи.Дата, МЕСЯЦ))
	|	ГДЕ
	|		ТаблицаПередЗаписью.Организация ЕСТЬ NULL
	|		И ТаблицаПослеЗаписи.Проведен = ИСТИНА
	|
	|	) КАК Таблица
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыПогашенияСтоимостиТМЦ КАК ПакетыПогашенияСтоимостиТМЦ
	|	ПО ПакетыПогашенияСтоимостиТМЦ.Организация = Таблица.Организация
	|		И ПакетыПогашенияСтоимостиТМЦ.Партия = Таблица.Партия
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Организация,
	|	ЕСТЬNULL(ПакетыПогашенияСтоимостиТМЦ.НомерПакета, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ РегистрацияНаработокТМЦВЭксплуатации_Наработки_ПослеЗаписи";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Проведен", ?(ОтменаПроведения, Ложь, Проведен));
	Запрос.УстановитьПараметр("Наработки", Наработки.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	РегистрыСведений.ЗаданияКПогашениюСтоимостиТМЦВЭксплуатации.СоздатьЗаписиРегистраПоДаннымВыборки(РезультатЗапроса.Выбрать());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли