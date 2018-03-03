﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ИИЦИАЛИЗАЦИИ И ЗАПОЛНЕНИЯ РЕГИСТРАЦИИ ЦЕН ПОСТАВЩИКА

Процедура ЗаполнитьДокументНаОснованииПартнера(Основание)
	
	Партнер = Основание;
	
КонецПроцедуры

// Заполняет регистрацию цен номенклатуры поставщика на основании соглашения с партнером
//
// Параметры
//  Основание - Ссылка на партнера.
//
Процедура ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(Основание)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	СоглашениеСПоставщиком.Партнер КАК Партнер,
		|	СоглашениеСПоставщиком.Ссылка  КАК Соглашение
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
		|ГДЕ
		|	СоглашениеСПоставщиком.Ссылка = &Ссылка
		|");
		
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

// Заполняет регистрацию цен в соответствии с отбором
//
// Параметры:
// ДанныеЗаполнения - Структура - Структура со значениями отбора
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Соглашение") Тогда
		
		Соглашение = ДанныеЗаполнения.Соглашение;
		ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(Соглашение);
		
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения.Партнер);
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует установку цен номенклатуры партнеров.
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СоглашенияСПоставщиками") Тогда
		ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Документы.РегистрацияЦенНоменклатурыПоставщика.ЗаполнитьРегистрациюЦенПоДокументуЗакупки(ДанныеЗаполнения, ЭтотОбъект);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Документы.РегистрацияЦенНоменклатурыПоставщика.ЗаполнитьРегистрациюЦенПоДокументуЗакупки(ДанныеЗаполнения, ЭтотОбъект);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	Документы.РегистрацияЦенНоменклатурыПоставщика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Ценообразование.ОтразитьЦеныНоменклатурыПоставщика(ДополнительныеСвойства, Движения, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

#КонецОбласти

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Партнер;
	
КонецПроцедуры

#КонецЕсли
