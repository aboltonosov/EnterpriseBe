﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет таможенную декларацию на экспорт данными из документа-основания
//
// Параметры:
//	Основание - ДокументСсылка - ссылка на документ-основание
//
Процедура ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию(Основание) Экспорт
	
	Если Не ЗначениеЗаполнено(Основание) Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Проведен    КАК Проведен,
	|	РеализацияТоваровУслуг.Ссылка      КАК ДокументОснование,
	|	РеализацияТоваровУслуг.Организация КАК Организация
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка = &Основание");
	
	Запрос.УстановитьПараметр("Основание", Основание);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Основание,
		,
		НЕ Реквизиты.Проведен);
		
	//Заполнение шапки
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты, "Организация");
	
	Строка = ДокументыОснования.Добавить();
	Строка.ДокументОснование = Основание;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено 
		И (ТипДанныхЗаполнения = Тип("Массив") ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда

		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ИначеЕсли ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДокументОснование")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.ДокументОснование.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения.ДокументОснование, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьТаблицуОснований(Отказ);
	ПровестиФЛКНомераДекларации(Отказ);
	ПроверитьСопроводительныеДокументы(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ТаможеннаяДекларацияЭкспорт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Документы.ТаможеннаяДекларацияЭкспорт.ОтразитьСведенияТаможенныхДекларацийЭкспорт(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДокументыОснования(Отказ);
	
	РеализацииЭкспорт = ЭтотОбъект.ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
	РегистрыСведений.ТаможенныеДекларацииЭкспортКРегистрации.ОбновитьСостояние(РеализацииЭкспорт);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументыОснования.Очистить();
	ДокументОснование = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоДокументуОснованию(Основание, СтандартнаяОбработка)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Если Основание.НалогообложениеНДС <> Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт Тогда
			Ошибка = НСтр("ru='Ввод таможенной декларации на экспорт на основании реализации с видом налогообложения НДС %Налогообложение% не требуется.'");
			СтандартнаяОбработка = Ложь;
			ВызватьИсключение СтрЗаменить(Ошибка, "%Налогообложение%", Основание.НалогообложениеНДС);
		ИначеЕсли ЕстьТаможеннаяДекларацияЭкспорт(Основание) Тогда
			Ошибка = НСтр("ru='На основании реализации уже введена таможенная декларация.'");
			СтандартнаяОбработка = Ложь;
			ВызватьИсключение СтрЗаменить(Ошибка, "%Налогообложение%", Основание.НалогообложениеНДС);
		КонецЕсли;
		
		ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию(Основание);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("Массив") И Основание.Количество() > 0 Тогда
		
		// МассивОснований = ПолучитьМассив
		
		ОрганизацииДокументовОснований = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Основание, "Организация, НалогообложениеНДС");
		
		ЗаполнитьПоДокументуОснованию(Основание[0], СтандартнаяОбработка);
		
		Если Основание.Количество() > 1 Тогда
			
			ЭтотОбъект.ДокументыОснования.Очистить();
			
			Для Каждого ДокОснование Из Основание Цикл
				Если ОрганизацииДокументовОснований[ДокОснование].НалогообложениеНДС <> Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт Тогда
					Продолжить;
				КонецЕсли;
				
				Если ЭтотОбъект.Организация <> ОрганизацииДокументовОснований[ДокОснование].Организация Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = ЭтотОбъект.ДокументыОснования.Добавить();
				НоваяСтрока.ДокументОснование = ДокОснование;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиПроверкиЗаполнения

Процедура ПровестиФЛКНомераДекларации(Отказ)
	
	ДлинаНомера = СтрДлина(СокрЛП(Номер));
	Если ДлинаНомера = 23 ИЛИ (ДлинаНомера >= 25 И ДлинаНомера <= 29) Тогда
		Возврат;
		
	Иначе
		ТекстСообщения =
			НСтр("ru='Регистрационный номер таможенной декларации должен состоять либо из 23 символов, либо количество символов должно быть от 25 до 29.'");
			
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле",
			"Корректность",
			"Номер", , ,
			ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Номер", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьТаблицуОснований(Отказ)
	
	Если ДокументыОснования.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки в список ""Основания""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДокументыОснованияПредставление", , Отказ);
	КонецЕсли;
	
	СоответствиеОснований = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"), "Проведен");
	Для каждого СтрокаТЧ Из ДокументыОснования Цикл
		Если СоответствиеОснований[СтрокаТЧ.ДокументОснование].Проведен = Ложь Тогда
			
			ТекстСообщения = НСтр("ru = 'Таможенную декларацию можно провести только на основании проведенного документа.'");
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Корректность",
				НСтр("ru='Основания'"),
				СтрокаТЧ.НомерСтроки,
				НСтр("ru='Документы-основания таможенной декларации'"),
				ТекстСообщения);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДокументыОснованияПредставление", , Отказ);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьСопроводительныеДокументы(Отказ)
	
	Для Каждого СопроводительныйДокумент Из СопроводительныеДокументы Цикл
		
		Префикс = "Объект.СопроводительныеДокументы[%1].";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(СопроводительныйДокумент.НомерСтроки - 1, "ЧН=0; ЧГ="));
			
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.КодТС) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru='Код ТС'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru='Сопроводительные документы'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "КодТС", , Отказ);
		КонецЕсли;
		
		Если СопроводительныйДокумент.КодТС = "71" ИЛИ СопроводительныйДокумент.КодТС = "72" Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.ВидДокумента) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru='Вид документа'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru='Сопроводительные документы'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "ВидДокумента", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.НомерТСД) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru='Номер'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru='Сопроводительные документы'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "НомерТСД", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СопроводительныйДокумент.ДатаТСД) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Колонка",
				"Заполнение",
				НСтр("ru='Дата'"),
				СопроводительныйДокумент.НомерСтроки,
				НСтр("ru='Сопроводительные документы'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Префикс + "ДатаТСД", , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Функция ЕстьТаможеннаяДекларацияЭкспорт(Основания)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"";
	
	Возврат Ложь;
	
КонецФункции

Процедура ПроверитьДокументыОснования(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ2.Ссылка
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК Документ1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК Документ2
	|		ПО Документ1.ДокументОснование = Документ2.ДокументОснование
	|ГДЕ
	|	Документ2.Ссылка.Проведен
	|	И Документ1.Ссылка = &Ссылка
	|	И Документ2.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СообщениеПользователю = Новый СообщениеПользователю;
			ТекстСообщения = НСтр("ru = 'На основании документа ""%ДокументОснование%"" уже введена ""%ТаможеннаяДекларация%"". Документ не записан.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТаможеннаяДекларация%", Ссылка);
			СообщениеПользователю.Текст = ТекстСообщения;
			СообщениеПользователю.Сообщить();
		КонецЦикла; 
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли