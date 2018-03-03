﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ОтветПередЗаписью;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Параметры.Свойство("Владелец") Тогда
			Объект.Владелец = Параметры.Владелец;
		КонецЕсли;
		
		Если Параметры.Свойство("Номенклатура") Тогда
			Объект.Номенклатура = Параметры.Номенклатура;
		КонецЕсли;
		
		Если Параметры.Свойство("Характеристика") Тогда
			Объект.Характеристика = Параметры.Характеристика;
		КонецЕсли;
		
		Если Параметры.Свойство("Упаковка") Тогда
			Объект.Упаковка = Параметры.Упаковка;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтветПередЗаписью = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ОтветПередЗаписью и ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		
		ДубльНоменклатурыПоставщика = НайтиДубльНоменклатурыПоставщика(Объект.Ссылка, Объект.Владелец, Объект.Номенклатура, Объект.Характеристика, Объект.Упаковка);
		
		Если ДубльНоменклатурыПоставщика <> Неопределено Тогда
			
			ТекстВопроса = НСтр("ru='Найдена номенклатура ""%ДубльНоменклатурыПоставщика%"", для которой уже задано аналогичное соответствие номенклатуре.'");
			ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru='Продолжить запись текущего элемента?'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ДубльНоменклатурыПоставщика%", ДубльНоменклатурыПоставщика);
			
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		Записать();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииСервер(КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура НоменклатураПриИзмененииСервер(КэшированныеЗначения)
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Объект.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", Объект.Упаковка);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Объект.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Объект.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	СтруктураСтроки.Вставить("Упаковка", Объект.Упаковка);

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Объект"));

	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Объект, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	Справочники.УпаковкиЕдиницыИзмерения.ОтобразитьИнформациюОЕдиницеХранения(Объект.Номенклатура, Элементы.Упаковка);
	
КонецПроцедуры

Функция НайтиДубльНоменклатурыПоставщика(Ссылка, Партнер, Номенклатура, Характеристика, Упаковка)
	
	Запрос = Новый Запрос("
		|ВЫБРАТь ПЕРВЫЕ 1
		|	НоменклатураПоставщиков.Ссылка КАК НоменклатураПоставщика
		|ИЗ
		|	Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|ГДЕ
		|	НоменклатураПоставщиков.Владелец = &Партнер
		|	И НоменклатураПоставщиков.Номенклатура = &Номенклатура
		|	И НоменклатураПоставщиков.Характеристика = &Характеристика
		|	И (НоменклатураПоставщиков.Упаковка = &Упаковка)
		|	И НЕ НоменклатураПоставщиков.ЭтоГруппа
		|	И НЕ НоменклатураПоставщиков.ПометкаУдаления
		|	И НоменклатураПоставщиков.Ссылка <> &Ссылка
		|");
	
	Запрос.УстановитьПараметр("Партнер",        Партнер);
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Упаковка",       Упаковка);
	Запрос.УстановитьПараметр("Ссылка",         Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.НоменклатураПоставщика;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
	Справочники.УпаковкиЕдиницыИзмерения.ОтобразитьИнформациюОЕдиницеХранения(Объект.Номенклатура, Элементы.Упаковка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
