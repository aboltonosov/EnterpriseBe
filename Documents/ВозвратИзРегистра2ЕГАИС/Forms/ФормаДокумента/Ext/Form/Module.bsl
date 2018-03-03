﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// МенюОтчеты
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьПодменюОтчеты(ЭтотОбъект);
	// Конец МенюОтчеты
	
	// ВводНаОсновании
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьПодменюСоздатьНаОсновании(ЭтотОбъект);
	// Конец ВводНаОсновании
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыУпаковка");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ ТолькоПросмотр Тогда
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
			Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
			ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.ДокументОснование);
	Оповестить("Запись_ВозвратИзРегистра2ЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ ТолькоПросмотр Тогда
		СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправка2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Отбор.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправка2ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Справка2) Тогда
			ТекущиеДанные.АлкогольнаяПродукция = ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Справка2, "АлкогольнаяПродукция");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.ВозвратИзРегистра2ЕГАИС.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет перезаполнена. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСправки2(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Организация ЕГАИС""'"),
			Объект.Ссылка, "Объект.ОрганизацияЕГАИС");
		Возврат;
	КонецЕсли;
	
	СправкиЗаполнены = ПодобратьСправки2НаСервере();
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииЗаполненияСправок(СправкиЗаполнены, Истина);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбновитьСтатусЕГАИС();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ДоступностьЭлементовФормы();
	
КонецПроцедуры

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ДанныеШтрихкодов = Новый Массив;
	ДанныеШтрихкодов.Добавить(ДанныеШтрихкода);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		Новый ОписаниеОповещения("Подключаемый_ПолученыДанныеИзТСД", ЭтотОбъект),
		ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодов, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
		ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(ЭтотОбъект, ВыбранноеЗначение, ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется;
	ЦветТекста         = Неопределено;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиВозвратаИзРегистра2ЕГАИС.Новый
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиВозвратаИзРегистра2ЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные;
		
	КонецЕсли;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиВозвратаИзРегистра2ЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ЦветТекста = ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи;
		
	КонецЕсли;
	
	ТекстПредставление = Новый ФорматированнаяСтрока(Строка(Объект.СтатусОбработки),,ЦветТекста);
	
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(ТекстПредставление, ДальнейшееДействие);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		ПередатьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные()
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ВозвратИзРегистра2");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ИнтеграцияЕГАИСКлиент),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура ДоступностьЭлементовФормы()
	
	ТолькоПросмотр =
		Объект.СтатусОбработки <> Перечисления.СтатусыОбработкиВозвратаИзРегистра2ЕГАИС.Новый
		И Объект.СтатусОбработки <> Перечисления.СтатусыОбработкиВозвратаИзРегистра2ЕГАИС.ОшибкаПередачиВЕГАИС;
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

&НаСервере
Функция ПодобратьСправки2НаСервере()
	
	СправкиЗаполнены = Документы.ВозвратИзРегистра2ЕГАИС.ПодобратьСправки2(Объект);
	
	Возврат СправкиЗаполнены;
	
КонецФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти